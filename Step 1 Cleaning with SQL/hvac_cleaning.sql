-- hvac_cleaning.sql
-- Data cleaning & feature engineering for HVAC anomaly detection


-----------------------------------------------------------
-- 1. A working copy from the raw table was created for safe data handling
-----------------------------------------------------------

CREATE TABLE IF NOT EXISTS hvac_clean AS
SELECT *
FROM hvac_raw;

-----------------------------------------------------------
-- 2. Add engineered feature columns if they don't already exist
-----------------------------------------------------------

-- temp_error: difference between actual return temp and setpoint
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'hvac_clean'
          AND column_name = 'temp_error'
    ) THEN
        ALTER TABLE hvac_clean
        ADD COLUMN temp_error DOUBLE PRECISION;
    END IF;
END$$;

-- delta_supply_return: difference between return and supply temp
-- (t_return - t_supply)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'hvac_clean'
          AND column_name = 'delta_supply_return'
    ) THEN
        ALTER TABLE hvac_clean
        ADD COLUMN delta_supply_return DOUBLE PRECISION;
    END IF;
END$$;

-- anomaly_flag: rule-based anomaly label (0 = normal, 1 = anomaly)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'hvac_clean'
          AND column_name = 'anomaly_flag'
    ) THEN
        ALTER TABLE hvac_clean
        ADD COLUMN anomaly_flag INT;
    END IF;
END$$;


-----------------------------------------------------------
-- 3. Populate engineered columns
-----------------------------------------------------------

-- temp_error: how far actual return temperature is from setpoint
UPDATE hvac_clean
SET temp_error = t_return - sp_return;

-- delta_supply_return measures how different the return air temperature is 
-- from the supply air temperature. This helps indicate how well the HVAC 
-- system is transferring heat. A large positive value means the return air 
-- is much warmer than the supply (cooling mode), while a large negative 
-- value means the supply air is warmer than the return (heating mode). 
-- This feature becomes a key signal for classifying system_state and 
-- detecting anomalies.
UPDATE hvac_clean
SET delta_supply_return = t_return - t_supply;


-----------------------------------------------------------
-- 4. Derive system_state from sensor behavior
--    (heating / cooling / idle) based on delta_supply_return
-----------------------------------------------------------

UPDATE hvac_clean
SET system_state =
    CASE
        WHEN delta_supply_return >= 5  THEN 'cooling'  -- return much warmer than supply -> cooling
        WHEN delta_supply_return <= -2 THEN 'heating'  -- supply much warmer than return -> heating
        ELSE 'idle'
    END;

-----------------------------------------------------------
-- 5. Rule-based anomaly logic (sets anomaly_flag)
-----------------------------------------------------------

UPDATE hvac_clean
SET anomaly_flag =
    CASE
        -- 1) Heating anomalies: labeled heating but delta too weak or too extreme
        WHEN system_state = 'heating'
             AND (delta_supply_return > -1.5 OR delta_supply_return < -7.5)
        THEN 1

        -- 2) Cooling anomalies: labeled cooling but delta too weak or too extreme
        WHEN system_state = 'cooling'
             AND (delta_supply_return < 4 OR delta_supply_return > 13)
        THEN 1

        -- 3) Idle anomalies: idle but temp difference is big or power is high
        WHEN system_state = 'idle'
             AND (ABS(delta_supply_return) > 4 OR power_kw > 12)
        THEN 1

        -- Otherwise: normal
        ELSE 0
    END;



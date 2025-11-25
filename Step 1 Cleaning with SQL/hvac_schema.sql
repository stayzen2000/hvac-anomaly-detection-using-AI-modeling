-- hvac_schema.sql
-- PostgreSQL schema for hvac_clean table

DROP TABLE IF EXISTS hvac_clean;

CREATE TABLE hvac_clean (
    timestamp           TIMESTAMP WITHOUT TIME ZONE,
    t_return            DOUBLE PRECISION,
    t_supply            DOUBLE PRECISION,
    t_outdoor           DOUBLE PRECISION,
    rh_return           DOUBLE PRECISION,
    rh_supply           DOUBLE PRECISION,
    rh_outdoor          DOUBLE PRECISION,
    sp_return           DOUBLE PRECISION,
    t_saturation        DOUBLE PRECISION,
    power_kw            DOUBLE PRECISION,
    energy_kwh          DOUBLE PRECISION,
    temp_error          DOUBLE PRECISION,
    delta_supply_return DOUBLE PRECISION,
    system_state        TEXT,
    anomaly_flag        INTEGER
);

-- Optional: basic index on timestamp for time-series querying
CREATE INDEX IF NOT EXISTS idx_hvac_timestamp
    ON hvac_clean (timestamp);

-- Optional: index on anomaly_flag for faster filtering on anomalies
CREATE INDEX IF NOT EXISTS idx_hvac_anomaly_flag
    ON hvac_clean (anomaly_flag);

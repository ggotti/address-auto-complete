
ATTACH DATABASE '/map/fullGNAF.db' As 'GNAF';

CREATE TABLE ADDRESS(
  ADDRESS_DETAIL_PID TEXT PRIMARY KEY ,
  STREET_LOCALITY_PID TEXT,
  LOCALITY_PID TEXT,
  BUILDING_NAME TEXT,
  LOT_NUMBER_PREFIX TEXT,
  LOT_NUMBER TEXT,
  LOT_NUMBER_SUFFIX TEXT,
  FLAT_TYPE TEXT,
  FLAT_NUMBER_PREFIX TEXT,
  FLAT_NUMBER NUM,
  FLAT_NUMBER_SUFFIX TEXT,
  LEVEL_TYPE TEXT,
  LEVEL_NUMBER_PREFIX TEXT,
  LEVEL_NUMBER NUM,
  LEVEL_NUMBER_SUFFIX TEXT,
  NUMBER_FIRST_PREFIX TEXT,
  NUMBER_FIRST NUM,
  NUMBER_FIRST_SUFFIX TEXT,
  NUMBER_LAST_PREFIX TEXT,
  NUMBER_LAST NUM,
  NUMBER_LAST_SUFFIX TEXT,
  STREET_NAME TEXT,
  STREET_CLASS_CODE TEXT,
  STREET_CLASS_TYPE TEXT,
  STREET_TYPE_CODE TEXT,
  STREET_SUFFIX_CODE TEXT,
  STREET_SUFFIX_TYPE TEXT,
  LOCALITY_NAME TEXT,
  STATE_ABBREVIATION TEXT,
  POSTCODE TEXT,
  LATITUDE NUM,
  LONGITUDE NUM,
  GEOCODE_TYPE TEXT,
  CONFIDENCE NUM,
  ALIAS_PRINCIPAL TEXT,
  PRIMARY_SECONDARY TEXT,
  LEGAL_PARCEL_ID TEXT,
  DATE_CREATED NUM
);

CREATE TABLE ADDRESS_TEXT(
  ADDRESS_DETAIL_PID TEXT PRIMARY KEY ,
  ADDRESS_AS_TEXT TEXT
);

CREATE INDEX address_text_index ON ADDRESS_TEXT(ADDRESS_AS_TEXT COLLATE NOCASE);

INSERT INTO ADDRESS SELECT * FROM GNAF.ADDRESS_VIEW av;

INSERT INTO ADDRESS_TEXT SELECT ad.address_detail_pid,
       -- CASE WHEN lot_number IS NULL THEN NULL ELSE CONCAT_WS(' ', 'LOT', lot_number_prefix, lot_number, lot_number_suffix) END,
       CASE WHEN lot_number IS NULL THEN '' ELSE
           'LOT ' ||
           IFNULL(lot_number_prefix, '') ||
           CASE WHEN(IFNULL(lot_number_prefix, '') <> '' AND IFNULL(lot_number, '') <> '' OR IFNULL(lot_number_suffix, '') <> '' ) THEN ' ' ELSE '' END ||
           IFNULL(lot_number,'') ||
           CASE WHEN(IFNULL(lot_number, '') <> '' AND IFNULL(lot_number_suffix, '') <> '' ) THEN ' ' ELSE '' END ||
           IFNULL(lot_number_suffix,'')
       END ||
        -- --   flat_type_code, flat_number_prefix, flat_number, flat_number_suffix,
       -- --   level_type_code, level_number_prefix, level_number, level_number_suffix,
       CASE WHEN(flat_type_code IS NULL) THEN '' ELSE flat_type_code || ' ' END  ||
       CASE WHEN(flat_number_prefix IS NULL) THEN '' ELSE flat_number_prefix || ' ' END  ||
       CASE WHEN(flat_number IS NULL) THEN '' ELSE flat_number || ' ' END  ||
       CASE WHEN(flat_number_suffix IS NULL) THEN '' ELSE flat_number_suffix || ' ' END  ||
       CASE WHEN(level_type_code IS NULL) THEN '' ELSE level_type_code || ' ' END  ||
       CASE WHEN(level_number_prefix IS NULL) THEN '' ELSE level_number_prefix || ' ' END  ||
       CASE WHEN(level_number IS NULL) THEN '' ELSE level_number || ' ' END  ||
       CASE WHEN(level_number_suffix IS NULL) THEN '' ELSE level_number_suffix || ' ' END  ||
       CASE WHEN (IFNULL(number_first, '') <> '' OR IFNULL(number_last, '') <> '') THEN
           -- NULLIF(CONCAT_WS('', number_first_prefix, number_first, number_first_suffix), ''),
           IFNULL(number_first_prefix,'') ||
           CASE WHEN(IFNULL(number_first_prefix, '') <> '' AND (IFNULL(number_first, '') <> '' OR IFNULL(number_first_suffix, '') <> '' )) THEN ' ' ELSE '' END ||
           IFNULL(number_first,'') ||
           CASE WHEN(IFNULL(number_first, '') <> '' AND IFNULL(number_first_suffix, '') <> '' ) THEN ' ' ELSE '' END ||
           IFNULL(number_first_suffix,'') || '' ||
           -- -
           CASE WHEN (IFNULL(number_first, '') <> '' AND IFNULL(number_last, '') <> '') THEN
                '-'
           ELSE
               ''
           END ||
           -- NULLIF(CONCAT_WS('', number_last_prefix, number_last, number_last_suffix), '')
           IFNULL(number_last_prefix,'') ||
           CASE WHEN(IFNULL(number_last_prefix, '') <> '' AND IFNULL(number_last, '') <> '' OR IFNULL(number_last_suffix, '') <> '' ) THEN ' ' ELSE '' END ||
           IFNULL(number_last,'') ||
           CASE WHEN(IFNULL(number_last, '') <> '' AND IFNULL(number_last_suffix, '') <> '' ) THEN ' ' ELSE '' END ||
           IFNULL(number_last_suffix,'')
       ELSE
           ''
       END ||
       ' ' ||
       IFNULL(street_name, '') || ' ' || CASE WHEN(street_type_code IS NULL) THEN '' ELSE street_type_code || ' ' END || locality_name || ' ' || state_abbreviation
 as "address"
FROM GNAF.ADDRESS_DETAIL ad
JOIN GNAF.ADDRESS_SITE s ON (ad.address_site_pid = s.address_site_pid)
JOIN GNAF.STREET_LOCALITY sl ON (ad.street_locality_pid = sl.street_locality_pid)
JOIN GNAF.LOCALITY l ON (ad.locality_pid = l.locality_pid)
JOIN GNAF.STATE t ON (l.state_pid = t.state_pid);

PRAGMA case_sensitive_like = 0;

DETACH DATABASE 'GNAF';

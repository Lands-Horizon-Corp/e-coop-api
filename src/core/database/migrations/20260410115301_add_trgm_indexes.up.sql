CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_member_profiles_search_trgm
ON member_profiles USING gin (
  full_name gin_trgm_ops,
  first_name gin_trgm_ops,
  last_name gin_trgm_ops,
  old_reference_id gin_trgm_ops,
  passbook gin_trgm_ops
);

CREATE INDEX IF NOT EXISTS idx_accounts_search_trgm
ON accounts USING gin (
  name gin_trgm_ops,
  description gin_trgm_ops
);
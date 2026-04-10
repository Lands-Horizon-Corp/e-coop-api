-- Enable required PostgreSQL extensions.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

-- create "media" table
CREATE TABLE "media" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "file_name" character varying(2048) NULL,
  "file_size" bigint NULL,
  "file_type" character varying(255) NULL,
  "storage_key" character varying(2048) NULL,
  "key" character varying(2048) NULL,
  "bucket_name" character varying(2048) NULL,
  "status" character varying(50) NULL DEFAULT 'pending',
  "progress" bigint NULL,
  PRIMARY KEY ("id")
);
-- create index "idx_media_deleted_at" to table: "media"
CREATE INDEX "idx_media_deleted_at" ON "media" ("deleted_at");
-- create "contact_us" table
CREATE TABLE "contact_us" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "first_name" character varying(255) NOT NULL,
  "last_name" character varying(255) NULL,
  "email" character varying(255) NULL,
  "contact_number" character varying(20) NULL,
  "description" text NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id")
);
-- create index "idx_contact_us_deleted_at" to table: "contact_us"
CREATE INDEX "idx_contact_us_deleted_at" ON "contact_us" ("deleted_at");
-- create "users" table
CREATE TABLE "users" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "media_id" uuid NULL,
  "signature_media_id" uuid NULL,
  "password" character varying(255) NOT NULL,
  "birthdate" date NULL,
  "username" character varying(100) NOT NULL,
  "first_name" character varying(100) NULL,
  "middle_name" character varying(100) NULL,
  "last_name" character varying(100) NULL,
  "full_name" character varying(255) NULL,
  "suffix" character varying(50) NULL,
  "description" text NULL,
  "email" character varying(255) NOT NULL,
  "is_email_verified" boolean NULL DEFAULT false,
  "contact_number" character varying(50) NOT NULL,
  "is_contact_verified" boolean NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_users_contact_number" UNIQUE ("contact_number"),
  CONSTRAINT "uni_users_email" UNIQUE ("email"),
  CONSTRAINT "uni_users_username" UNIQUE ("username"),
  CONSTRAINT "fk_users_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_users_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_users_deleted_at" to table: "users"
CREATE INDEX "idx_users_deleted_at" ON "users" ("deleted_at");
-- create "currencies" table
CREATE TABLE "currencies" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "name" character varying(255) NOT NULL,
  "country" character varying(255) NOT NULL,
  "currency_code" character varying(10) NOT NULL,
  "symbol" character varying(10) NULL,
  "emoji" character varying(10) NULL,
  "iso3166_alpha2" character varying(2) NULL,
  "iso3166_alpha3" character varying(3) NULL,
  "iso3166_numeric" character varying(3) NULL,
  "phone_code" character varying(10) NULL,
  "domain" character varying(10) NULL,
  "locale" character varying(10) NULL,
  "timezone" character varying(50) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_currencies_name" UNIQUE ("name")
);
-- create index "idx_currencies_deleted_at" to table: "currencies"
CREATE INDEX "idx_currencies_deleted_at" ON "currencies" ("deleted_at");
-- create "subscription_plans" table
CREATE TABLE "subscription_plans" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "name" character varying(255) NOT NULL,
  "description" text NOT NULL,
  "cost" numeric(10,2) NOT NULL,
  "timespan" bigint NOT NULL,
  "max_branches" bigint NOT NULL,
  "max_employees" bigint NOT NULL,
  "max_members_per_branch" bigint NOT NULL,
  "discount" numeric(5,2) NULL DEFAULT 0,
  "yearly_discount" numeric(5,2) NULL DEFAULT 0,
  "is_recommended" boolean NOT NULL DEFAULT false,
  "has_api_access" boolean NOT NULL DEFAULT false,
  "has_flexible_org_structures" boolean NOT NULL DEFAULT false,
  "has_ai_enabled" boolean NOT NULL DEFAULT false,
  "has_machine_learning" boolean NOT NULL DEFAULT false,
  "max_api_calls_per_month" bigint NULL DEFAULT 0,
  "currency_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_subscription_plans_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_subscription_plans_deleted_at" to table: "subscription_plans"
CREATE INDEX "idx_subscription_plans_deleted_at" ON "subscription_plans" ("deleted_at");
-- create "organizations" table
CREATE TABLE "organizations" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "address" character varying(500) NULL,
  "email" character varying(255) NULL,
  "contact_number" character varying(20) NULL,
  "description" text NULL,
  "color" character varying(50) NULL,
  "theme" text NULL,
  "terms_and_conditions" text NULL,
  "privacy_policy" text NULL,
  "cookie_policy" text NULL,
  "refund_policy" text NULL,
  "user_agreement" text NULL,
  "is_private" boolean NULL DEFAULT false,
  "instagram_link" character varying(255) NULL,
  "facebook_link" character varying(255) NULL,
  "youtube_link" character varying(255) NULL,
  "personal_website_link" character varying(255) NULL,
  "x_link" character varying(255) NULL,
  "media_id" uuid NULL,
  "cover_media_id" uuid NULL,
  "subscription_plan_max_branches" bigint NOT NULL,
  "subscription_plan_max_employees" bigint NOT NULL,
  "subscription_plan_max_members_per_branch" bigint NOT NULL,
  "subscription_plan_id" uuid NULL,
  "subscription_start_date" timestamptz NULL,
  "subscription_end_date" timestamptz NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_organizations_cover_media" FOREIGN KEY ("cover_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_subscription_plans_organizations" FOREIGN KEY ("subscription_plan_id") REFERENCES "subscription_plans" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_organizations_deleted_at" to table: "organizations"
CREATE INDEX "idx_organizations_deleted_at" ON "organizations" ("deleted_at");
-- create "branches" table
CREATE TABLE "branches" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "type" character varying(100) NOT NULL,
  "name" character varying(255) NOT NULL,
  "email" character varying(255) NOT NULL,
  "description" text NULL,
  "currency_id" uuid NULL,
  "contact_number" character varying(20) NULL,
  "address" character varying(500) NOT NULL,
  "province" character varying(100) NOT NULL,
  "city" character varying(100) NOT NULL,
  "region" character varying(100) NOT NULL,
  "barangay" character varying(100) NOT NULL,
  "postal_code" character varying(20) NOT NULL,
  "latitude" double precision NULL,
  "longitude" double precision NULL,
  "is_main_branch" boolean NOT NULL DEFAULT false,
  "tax_identification_number" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branches_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branches_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branches_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branches_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branches_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_branches" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_branches_deleted_at" to table: "branches"
CREATE INDEX "idx_branches_deleted_at" ON "branches" ("deleted_at");
-- create "account_categories" table
CREATE TABLE "account_categories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_categories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_categories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_categories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_categories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_categories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_account_categories_deleted_at" to table: "account_categories"
CREATE INDEX "idx_account_categories_deleted_at" ON "account_categories" ("deleted_at");
-- create index "idx_organization_branch_account_category" to table: "account_categories"
CREATE INDEX "idx_organization_branch_account_category" ON "account_categories" ("organization_id", "branch_id");
-- create "account_classifications" table
CREATE TABLE "account_classifications" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_classifications_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_classifications_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_classifications_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_classifications_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_classifications_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_account_classifications_deleted_at" to table: "account_classifications"
CREATE INDEX "idx_account_classifications_deleted_at" ON "account_classifications" ("deleted_at");
-- create index "idx_organization_branch_account_classification" to table: "account_classifications"
CREATE INDEX "idx_organization_branch_account_classification" ON "account_classifications" ("organization_id", "branch_id");
-- create "computation_sheets" table
CREATE TABLE "computation_sheets" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(254) NULL,
  "description" text NULL,
  "deliquent_account" boolean NULL DEFAULT false,
  "fines_account" boolean NULL DEFAULT false,
  "interest_account_id" boolean NULL DEFAULT false,
  "comaker_account" numeric NULL DEFAULT -1,
  "number_of_months" bigint NULL DEFAULT 0,
  "exist_account" boolean NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_computation_sheets_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_computation_sheets_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_computation_sheets_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_computation_sheets_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_computation_sheets_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_computation_sheets_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_computation_sheets_deleted_at" to table: "computation_sheets"
CREATE INDEX "idx_computation_sheets_deleted_at" ON "computation_sheets" ("deleted_at");
-- create index "idx_organization_branch_computation_sheet" to table: "computation_sheets"
CREATE INDEX "idx_organization_branch_computation_sheet" ON "computation_sheets" ("organization_id", "branch_id");
-- create "financial_statement_titles" table
CREATE TABLE "financial_statement_titles" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "title" character varying(255) NOT NULL,
  "total_title" character varying(255) NOT NULL,
  "exclude_consolidated_total" boolean NOT NULL DEFAULT false,
  "index" integer NOT NULL DEFAULT 0,
  "color" character varying(50) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_financial_statement_titles_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_financial_statement_titles_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_financial_statement_titles_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_financial_statement_titles_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_financial_statement_titles_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_financial_statement_titles_deleted_at" to table: "financial_statement_titles"
CREATE INDEX "idx_financial_statement_titles_deleted_at" ON "financial_statement_titles" ("deleted_at");
-- create index "idx_organization_branch_financial_title" to table: "financial_statement_titles"
CREATE INDEX "idx_organization_branch_financial_title" ON "financial_statement_titles" ("organization_id", "branch_id");
-- create "member_types" table
CREATE TABLE "member_types" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "prefix" character varying(255) NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "browse_reference_description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_types_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_types_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_types_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_types_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_types_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_types_deleted_at" to table: "member_types"
CREATE INDEX "idx_member_types_deleted_at" ON "member_types" ("deleted_at");
-- create index "idx_organization_branch_member_type" to table: "member_types"
CREATE INDEX "idx_organization_branch_member_type" ON "member_types" ("organization_id", "branch_id");
-- create "general_ledger_definitions" table
CREATE TABLE "general_ledger_definitions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "created_by_id" uuid NULL,
  "updated_by_id" uuid NULL,
  "deleted_by_id" uuid NULL,
  "general_ledger_definition_entry_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "index" bigint NULL DEFAULT 0,
  "name_in_total" character varying(255) NULL,
  "is_posting" boolean NULL DEFAULT false,
  "general_ledger_type" character varying(50) NOT NULL,
  "beginning_balance_of_the_year_credit" numeric NULL DEFAULT 0,
  "beginning_balance_of_the_year_debit" numeric NULL DEFAULT 0,
  "budget_forecasting_of_the_year_percent" numeric NULL DEFAULT 0,
  "past_due" text NULL,
  "in_litigation" text NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_general_ledger_definitions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_ledger_definitions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_ledger_definitions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_ledger_definitions_general_ledger_definition_entries" FOREIGN KEY ("general_ledger_definition_entry_id") REFERENCES "general_ledger_definitions" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_general_ledger_definitions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_ledger_definitions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_general_ledger_definitions_deleted_at" to table: "general_ledger_definitions"
CREATE INDEX "idx_general_ledger_definitions_deleted_at" ON "general_ledger_definitions" ("deleted_at");
-- create index "idx_organization_branch_general_ledger_definition" to table: "general_ledger_definitions"
CREATE INDEX "idx_organization_branch_general_ledger_definition" ON "general_ledger_definitions" ("organization_id", "branch_id");
-- create "accounts" table
CREATE TABLE "accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "general_ledger_definition_id" uuid NULL,
  "account_classification_id" uuid NULL,
  "account_category_id" uuid NULL,
  "member_type_id" uuid NULL,
  "currency_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NOT NULL,
  "min_amount" numeric NULL DEFAULT 0,
  "max_amount" numeric NULL DEFAULT 50000,
  "index" numeric NULL DEFAULT 0,
  "type" character varying(50) NOT NULL,
  "is_internal" boolean NULL DEFAULT false,
  "cash_on_hand" boolean NULL DEFAULT false,
  "paid_up_share_capital" boolean NULL DEFAULT false,
  "computation_type" character varying(50) NULL DEFAULT 'Straight',
  "fines_amort" numeric NULL DEFAULT 0,
  "fines_maturity" numeric NULL DEFAULT 0,
  "interest_standard" numeric NULL DEFAULT 0,
  "interest_secured" numeric NULL DEFAULT 0,
  "computation_sheet_id" uuid NULL,
  "coh_cib_fines_grace_period_entry_cash_hand" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_cash_in_bank" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_daily_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_daily_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_weekly_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_weekly_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_monthly_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_monthly_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_semi_monthly_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_semi_monthly_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_quarterly_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_quarterly_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_semi_annual_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_semi_annual_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_annual_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_annual_maturity" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_lumpsum_amortization" numeric NULL DEFAULT 0,
  "coh_cib_fines_grace_period_entry_lumpsum_maturity" numeric NULL DEFAULT 0,
  "general_ledger_type" character varying(50) NULL,
  "loan_account_id" uuid NULL,
  "fines_grace_period_amortization" bigint NULL DEFAULT 0,
  "additional_grace_period" bigint NULL DEFAULT 0,
  "no_grace_period_daily" boolean NULL DEFAULT false,
  "fines_grace_period_maturity" bigint NULL DEFAULT 0,
  "yearly_subscription_fee" bigint NULL DEFAULT 0,
  "cut_off_days" bigint NULL DEFAULT 0,
  "cut_off_months" bigint NULL DEFAULT 0,
  "lumpsum_computation_type" character varying(50) NULL DEFAULT 'None',
  "interest_fines_computation_diminishing" character varying(100) NULL DEFAULT 'None',
  "interest_fines_computation_diminishing_straight_yearly" character varying(200) NULL DEFAULT 'None',
  "earned_unearned_interest" character varying(50) NULL DEFAULT 'None',
  "loan_saving_type" character varying(50) NULL DEFAULT 'Separate',
  "interest_deduction" character varying(10) NULL DEFAULT 'Above',
  "other_deduction_entry" character varying(20) NULL DEFAULT 'None',
  "interest_saving_type_diminishing_straight" character varying(20) NULL DEFAULT 'Spread',
  "other_information_of_an_account" character varying(50) NULL DEFAULT 'None',
  "header_row" bigint NULL DEFAULT 0,
  "center_row" bigint NULL DEFAULT 0,
  "total_row" bigint NULL DEFAULT 0,
  "general_ledger_grouping_exclude_account" boolean NULL DEFAULT false,
  "icon" character varying(50) NULL DEFAULT 'account',
  "show_in_general_ledger_source_withdraw" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_deposit" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_journal" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_payment" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_adjustment" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_journal_voucher" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_check_voucher" boolean NULL DEFAULT true,
  "compassion_fund" boolean NULL DEFAULT false,
  "compassion_fund_amount" numeric NULL DEFAULT 0,
  "cash_and_cash_equivalence" boolean NULL DEFAULT false,
  "interest_standard_computation" character varying(20) NULL DEFAULT 'None',
  "account_history_id" text NULL,
  "interest_amortization" numeric NULL DEFAULT 0,
  "interest_maturity" numeric NULL DEFAULT 0,
  "is_taxable" boolean NULL DEFAULT true,
  "is_included_in_general_ledger" boolean NOT NULL DEFAULT true,
  "is_included_in_financial_statement" boolean NOT NULL DEFAULT false,
  "net_surplus_positive_percentage1" numeric(20,4) NOT NULL DEFAULT 0,
  "net_surplus_positive_percentage2" numeric(20,4) NOT NULL DEFAULT 0,
  "net_surplus_negative_percentage1" numeric(20,4) NOT NULL DEFAULT 0,
  "net_surplus_negative_percentage2" numeric(20,4) NOT NULL DEFAULT 0,
  "gl_total_debit" numeric(20,4) NOT NULL DEFAULT 0,
  "gl_total_credit" numeric(20,4) NOT NULL DEFAULT 0,
  "gl_total_balance" numeric(20,4) NOT NULL DEFAULT 0,
  "financial_statement_title_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_accounts_account_category" FOREIGN KEY ("account_category_id") REFERENCES "account_categories" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_account_classification" FOREIGN KEY ("account_classification_id") REFERENCES "account_classifications" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_accounts_computation_sheet" FOREIGN KEY ("computation_sheet_id") REFERENCES "computation_sheets" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_financial_statement_title" FOREIGN KEY ("financial_statement_title_id") REFERENCES "financial_statement_titles" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_loan_account" FOREIGN KEY ("loan_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_ledger_definitions_accounts" FOREIGN KEY ("general_ledger_definition_id") REFERENCES "general_ledger_definitions" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_annual_am80d49614" CHECK ((coh_cib_fines_grace_period_entry_annual_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_annual_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_annual_maturity" CHECK ((coh_cib_fines_grace_period_entry_annual_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_annual_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_cash_hand" CHECK ((coh_cib_fines_grace_period_entry_cash_hand >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_cash_hand <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_cash_in_bank" CHECK ((coh_cib_fines_grace_period_entry_cash_in_bank >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_cash_in_bank <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_daily_amo6506db03" CHECK ((coh_cib_fines_grace_period_entry_daily_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_daily_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_daily_maturity" CHECK ((coh_cib_fines_grace_period_entry_daily_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_daily_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_lumpsum_a1150ec09" CHECK ((coh_cib_fines_grace_period_entry_lumpsum_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_lumpsum_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_lumpsum_maturity" CHECK ((coh_cib_fines_grace_period_entry_lumpsum_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_lumpsum_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_monthly_a4d861790" CHECK ((coh_cib_fines_grace_period_entry_monthly_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_monthly_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_monthly_maturity" CHECK ((coh_cib_fines_grace_period_entry_monthly_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_monthly_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_quarterly2820b13f" CHECK ((coh_cib_fines_grace_period_entry_quarterly_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_quarterly_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_quarterly682fa403" CHECK ((coh_cib_fines_grace_period_entry_quarterly_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_quarterly_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_semi_annu1c80b6f0" CHECK ((coh_cib_fines_grace_period_entry_semi_annual_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_semi_annual_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_semi_annu40130e80" CHECK ((coh_cib_fines_grace_period_entry_semi_annual_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_semi_annual_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_semi_mont80a49aa2" CHECK ((coh_cib_fines_grace_period_entry_semi_monthly_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_semi_monthly_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_semi_mont9b76bb7e" CHECK ((coh_cib_fines_grace_period_entry_semi_monthly_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_semi_monthly_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_weekly_am81c828d8" CHECK ((coh_cib_fines_grace_period_entry_weekly_amortization >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_weekly_amortization <= (100)::numeric)),
  CONSTRAINT "chk_accounts_coh_cib_fines_grace_period_entry_weekly_maturity" CHECK ((coh_cib_fines_grace_period_entry_weekly_maturity >= (0)::numeric) AND (coh_cib_fines_grace_period_entry_weekly_maturity <= (100)::numeric)),
  CONSTRAINT "chk_accounts_cut_off_days" CHECK ((cut_off_days >= 0) AND (cut_off_days <= 30)),
  CONSTRAINT "chk_accounts_cut_off_months" CHECK ((cut_off_months >= 0) AND (cut_off_months <= 12)),
  CONSTRAINT "chk_accounts_fines_amort" CHECK ((fines_amort >= (0)::numeric) AND (fines_amort <= (100)::numeric)),
  CONSTRAINT "chk_accounts_fines_maturity" CHECK ((fines_maturity >= (0)::numeric) AND (fines_maturity <= (100)::numeric))
);
-- create index "idx_account_name_org_branch" to table: "accounts"
CREATE UNIQUE INDEX "idx_account_name_org_branch" ON "accounts" ("organization_id", "branch_id", "name");
-- create index "idx_accounts_deleted_at" to table: "accounts"
CREATE INDEX "idx_accounts_deleted_at" ON "accounts" ("deleted_at");
-- create index "idx_organization_branch_account" to table: "accounts"
CREATE INDEX "idx_organization_branch_account" ON "accounts" ("organization_id", "branch_id");
-- create "account_histories" table
CREATE TABLE "account_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "account_id" uuid NOT NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "type" character varying(50) NULL,
  "min_amount" numeric NULL,
  "max_amount" numeric NULL,
  "index" numeric NULL DEFAULT 0,
  "is_internal" boolean NULL DEFAULT false,
  "cash_on_hand" boolean NULL DEFAULT false,
  "paid_up_share_capital" boolean NULL DEFAULT false,
  "computation_type" character varying(50) NULL,
  "fines_amort" numeric NULL,
  "fines_maturity" numeric NULL,
  "interest_standard" numeric NULL,
  "interest_secured" numeric NULL,
  "fines_grace_period_amortization" bigint NULL,
  "additional_grace_period" bigint NULL,
  "no_grace_period_daily" boolean NULL DEFAULT false,
  "fines_grace_period_maturity" bigint NULL,
  "yearly_subscription_fee" bigint NULL,
  "cut_off_days" bigint NULL DEFAULT 0,
  "cut_off_months" bigint NULL DEFAULT 0,
  "lumpsum_computation_type" character varying(50) NULL,
  "interest_fines_computation_diminishing" character varying(100) NULL,
  "interest_fines_computation_diminishing_straight_yearly" character varying(200) NULL,
  "earned_unearned_interest" character varying(50) NULL,
  "loan_saving_type" character varying(50) NULL,
  "interest_deduction" character varying(10) NULL,
  "other_deduction_entry" character varying(20) NULL,
  "interest_saving_type_diminishing_straight" character varying(20) NULL,
  "other_information_of_an_account" character varying(50) NULL,
  "general_ledger_type" character varying(50) NULL,
  "header_row" bigint NULL,
  "center_row" bigint NULL,
  "total_row" bigint NULL,
  "general_ledger_grouping_exclude_account" boolean NULL DEFAULT false,
  "icon" character varying(50) NULL,
  "show_in_general_ledger_source_withdraw" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_deposit" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_journal" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_payment" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_adjustment" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_journal_voucher" boolean NULL DEFAULT true,
  "show_in_general_ledger_source_check_voucher" boolean NULL DEFAULT true,
  "compassion_fund" boolean NULL DEFAULT false,
  "compassion_fund_amount" numeric NULL,
  "cash_and_cash_equivalence" boolean NULL DEFAULT false,
  "interest_standard_computation" character varying(20) NULL,
  "general_ledger_definition_id" uuid NULL,
  "account_classification_id" uuid NULL,
  "account_category_id" uuid NULL,
  "member_type_id" uuid NULL,
  "currency_id" uuid NULL,
  "computation_sheet_id" uuid NULL,
  "loan_account_id" uuid NULL,
  "coh_cib_fines_grace_period_entry_cash_hand" numeric NULL,
  "coh_cib_fines_grace_period_entry_cash_in_bank" numeric NULL,
  "coh_cib_fines_grace_period_entry_daily_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_daily_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_weekly_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_weekly_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_monthly_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_monthly_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_semi_monthly_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_semi_monthly_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_quarterly_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_quarterly_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_semi_annual_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_semi_annual_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_annual_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_annual_maturity" numeric NULL,
  "coh_cib_fines_grace_period_entry_lumpsum_amortization" numeric NULL,
  "coh_cib_fines_grace_period_entry_lumpsum_maturity" numeric NULL,
  "is_included_in_general_ledger" boolean NULL DEFAULT true,
  "is_included_in_financial_statement" boolean NULL DEFAULT false,
  "net_surplus_positive_percentage1" numeric NULL,
  "net_surplus_positive_percentage2" numeric NULL,
  "net_surplus_negative_percentage1" numeric NULL,
  "net_surplus_negative_percentage2" numeric NULL,
  "gl_total_debit" numeric NULL,
  "gl_total_credit" numeric NULL,
  "gl_total_balance" numeric NULL,
  "financial_statement_title_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_histories_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_account_histories_deleted_at" to table: "account_histories"
CREATE INDEX "idx_account_histories_deleted_at" ON "account_histories" ("deleted_at");
-- create index "idx_account_history_account" to table: "account_histories"
CREATE INDEX "idx_account_history_account" ON "account_histories" ("account_id");
-- create index "idx_account_history_org_branch" to table: "account_histories"
CREATE INDEX "idx_account_history_org_branch" ON "account_histories" ("organization_id", "branch_id");
-- create "account_tags" table
CREATE TABLE "account_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_accounts_account_tags" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_account_tags_deleted_at" to table: "account_tags"
CREATE INDEX "idx_account_tags_deleted_at" ON "account_tags" ("deleted_at");
-- create index "idx_organization_branch_account_tag" to table: "account_tags"
CREATE INDEX "idx_organization_branch_account_tag" ON "account_tags" ("organization_id", "branch_id");
-- create "account_transactions" table
CREATE TABLE "account_transactions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "source" character varying(50) NOT NULL,
  "jv_number" character varying(255) NOT NULL,
  "date" date NOT NULL,
  "description" text NULL,
  "debit" numeric(18,2) NULL DEFAULT 0,
  "credit" numeric(18,2) NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_transactions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_transactions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_transactions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_transactions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_transactions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_account_transactions_deleted_at" to table: "account_transactions"
CREATE INDEX "idx_account_transactions_deleted_at" ON "account_transactions" ("deleted_at");
-- create index "idx_org_branch_account_tx" to table: "account_transactions"
CREATE INDEX "idx_org_branch_account_tx" ON "account_transactions" ("organization_id", "branch_id");
-- create "account_transaction_entries" table
CREATE TABLE "account_transaction_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_transaction_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "debit" numeric(18,2) NULL DEFAULT 0,
  "credit" numeric(18,2) NULL DEFAULT 0,
  "date" date NOT NULL,
  "jv_number" character varying(255) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_account_transaction_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_account_transaction_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_transaction_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_transaction_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_transaction_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_account_transaction_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_account_transactions_entries" FOREIGN KEY ("account_transaction_id") REFERENCES "account_transactions" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_account_transaction_entries_account_id" to table: "account_transaction_entries"
CREATE INDEX "idx_account_transaction_entries_account_id" ON "account_transaction_entries" ("account_id");
-- create index "idx_account_transaction_entries_account_transaction_id" to table: "account_transaction_entries"
CREATE INDEX "idx_account_transaction_entries_account_transaction_id" ON "account_transaction_entries" ("account_transaction_id");
-- create index "idx_account_transaction_entries_deleted_at" to table: "account_transaction_entries"
CREATE INDEX "idx_account_transaction_entries_deleted_at" ON "account_transaction_entries" ("deleted_at");
-- create index "idx_date_account_tx_entry" to table: "account_transaction_entries"
CREATE INDEX "idx_date_account_tx_entry" ON "account_transaction_entries" ("date");
-- create index "idx_org_branch_account_tx_entry" to table: "account_transaction_entries"
CREATE INDEX "idx_org_branch_account_tx_entry" ON "account_transaction_entries" ("organization_id", "branch_id");
-- create "member_centers" table
CREATE TABLE "member_centers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_centers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_centers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_centers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_centers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_centers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_centers_deleted_at" to table: "member_centers"
CREATE INDEX "idx_member_centers_deleted_at" ON "member_centers" ("deleted_at");
-- create index "idx_organization_branch_member_center" to table: "member_centers"
CREATE INDEX "idx_organization_branch_member_center" ON "member_centers" ("organization_id", "branch_id");
-- create "member_classifications" table
CREATE TABLE "member_classifications" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "icon" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_classifications_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classifications_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classifications_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classifications_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classifications_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_classifications_deleted_at" to table: "member_classifications"
CREATE INDEX "idx_member_classifications_deleted_at" ON "member_classifications" ("deleted_at");
-- create index "idx_organization_branch_member_classification" to table: "member_classifications"
CREATE INDEX "idx_organization_branch_member_classification" ON "member_classifications" ("organization_id", "branch_id");
-- create "member_departments" table
CREATE TABLE "member_departments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "icon" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_departments_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_departments_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_departments_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_departments_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_departments_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_departments_deleted_at" to table: "member_departments"
CREATE INDEX "idx_member_departments_deleted_at" ON "member_departments" ("deleted_at");
-- create index "idx_organization_branch_member_department" to table: "member_departments"
CREATE INDEX "idx_organization_branch_member_department" ON "member_departments" ("organization_id", "branch_id");
-- create "member_genders" table
CREATE TABLE "member_genders" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_genders_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_genders_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_genders_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_genders_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_genders_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_genders_deleted_at" to table: "member_genders"
CREATE INDEX "idx_member_genders_deleted_at" ON "member_genders" ("deleted_at");
-- create index "idx_organization_branch_member_gender" to table: "member_genders"
CREATE INDEX "idx_organization_branch_member_gender" ON "member_genders" ("organization_id", "branch_id");
-- create "member_groups" table
CREATE TABLE "member_groups" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(50) NOT NULL,
  "description" text NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_groups_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_groups_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_groups_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_groups_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_groups_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_groups_deleted_at" to table: "member_groups"
CREATE INDEX "idx_member_groups_deleted_at" ON "member_groups" ("deleted_at");
-- create index "idx_organization_branch_member_group" to table: "member_groups"
CREATE INDEX "idx_organization_branch_member_group" ON "member_groups" ("organization_id", "branch_id");
-- create "member_occupations" table
CREATE TABLE "member_occupations" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_occupations_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_occupations_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_occupations_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_occupations_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_occupations_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_occupations_deleted_at" to table: "member_occupations"
CREATE INDEX "idx_member_occupations_deleted_at" ON "member_occupations" ("deleted_at");
-- create index "idx_organization_branch_member_occupation" to table: "member_occupations"
CREATE INDEX "idx_organization_branch_member_occupation" ON "member_occupations" ("organization_id", "branch_id");
-- create "member_profiles" table
CREATE TABLE "member_profiles" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "signature_media_id" uuid NULL,
  "user_id" uuid NULL,
  "member_type_id" uuid NULL,
  "member_group_id" uuid NULL,
  "member_gender_id" uuid NULL,
  "member_department_id" uuid NULL,
  "member_center_id" uuid NULL,
  "member_occupation_id" uuid NULL,
  "member_classification_id" uuid NULL,
  "member_verified_by_employee_user_id" uuid NULL,
  "recruited_by_member_profile_id" uuid NULL,
  "is_closed" boolean NOT NULL DEFAULT false,
  "is_mutual_fund_member" boolean NOT NULL DEFAULT true,
  "is_micro_finance_member" boolean NOT NULL DEFAULT true,
  "first_name" character varying(255) NOT NULL,
  "middle_name" character varying(255) NULL,
  "last_name" character varying(255) NOT NULL,
  "full_name" character varying(255) NOT NULL,
  "suffix" character varying(50) NULL,
  "birth_date" date NOT NULL,
  "status" character varying(50) NOT NULL DEFAULT 'pending',
  "description" text NULL,
  "notes" text NULL,
  "contact_number" character varying(255) NULL,
  "old_reference_id" character varying(50) NULL,
  "passbook" character varying(255) NULL,
  "occupation" character varying(255) NULL,
  "business_address" character varying(255) NULL,
  "business_contact_number" character varying(255) NULL,
  "civil_status" character varying(50) NOT NULL DEFAULT 'single',
  "birth_place" character varying(255) NULL,
  "latitude" double precision NULL,
  "longitude" double precision NULL,
  "sex" character varying(10) NOT NULL DEFAULT 'n/a',
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_profiles_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_center" FOREIGN KEY ("member_center_id") REFERENCES "member_centers" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_classification" FOREIGN KEY ("member_classification_id") REFERENCES "member_classifications" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_department" FOREIGN KEY ("member_department_id") REFERENCES "member_departments" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_gender" FOREIGN KEY ("member_gender_id") REFERENCES "member_genders" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_group" FOREIGN KEY ("member_group_id") REFERENCES "member_groups" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_occupation" FOREIGN KEY ("member_occupation_id") REFERENCES "member_occupations" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_profiles_member_verified_by_employee_user" FOREIGN KEY ("member_verified_by_employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profiles_recruited_members" FOREIGN KEY ("recruited_by_member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_member_profiles_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT
);
-- create index "idx_full_name" to table: "member_profiles"
CREATE INDEX "idx_full_name" ON "member_profiles" ("full_name");
-- create index "idx_member_profiles_deleted_at" to table: "member_profiles"
CREATE INDEX "idx_member_profiles_deleted_at" ON "member_profiles" ("deleted_at");
-- create index "idx_organization_branch_member_profile" to table: "member_profiles"
CREATE INDEX "idx_organization_branch_member_profile" ON "member_profiles" ("organization_id", "branch_id");
-- create "member_accounting_ledgers" table
CREATE TABLE "member_accounting_ledgers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "count" bigint NULL,
  "balance" numeric NULL,
  "interest" numeric NULL,
  "fines" numeric NULL,
  "due" numeric NULL,
  "carried_forward_due" numeric NULL,
  "stored_value_facility" numeric NULL,
  "principal_due" numeric NULL,
  "last_pay" timestamp NULL,
  "wallet" boolean NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_accounting_ledgers_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_accounting_ledgers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_accounting_ledgers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_accounting_ledgers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_accounting_ledgers_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_accounting_ledgers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_accounting_ledgers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_accounting_ledgers_deleted_at" to table: "member_accounting_ledgers"
CREATE INDEX "idx_member_accounting_ledgers_deleted_at" ON "member_accounting_ledgers" ("deleted_at");
-- create index "idx_organization_branch_member_accounting_ledger" to table: "member_accounting_ledgers"
CREATE INDEX "idx_organization_branch_member_accounting_ledger" ON "member_accounting_ledgers" ("organization_id", "branch_id");
-- create "loan_purposes" table
CREATE TABLE "loan_purposes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "description" text NULL,
  "icon" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_purposes_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_purposes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_purposes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_purposes_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_purposes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_purposes_deleted_at" to table: "loan_purposes"
CREATE INDEX "idx_loan_purposes_deleted_at" ON "loan_purposes" ("deleted_at");
-- create index "idx_organization_branch_loan_purpose" to table: "loan_purposes"
CREATE INDEX "idx_organization_branch_loan_purpose" ON "loan_purposes" ("organization_id", "branch_id");
-- create "loan_statuses" table
CREATE TABLE "loan_statuses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "icon" character varying(255) NULL,
  "color" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_statuses_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_statuses_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_statuses_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_statuses_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_statuses_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_statuses_deleted_at" to table: "loan_statuses"
CREATE INDEX "idx_loan_statuses_deleted_at" ON "loan_statuses" ("deleted_at");
-- create index "idx_organization_branch_loan_status" to table: "loan_statuses"
CREATE INDEX "idx_organization_branch_loan_status" ON "loan_statuses" ("organization_id", "branch_id");
-- create "banks" table
CREATE TABLE "banks" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_banks_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_banks_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_banks_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_banks_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_banks_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_banks_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_banks_deleted_at" to table: "banks"
CREATE INDEX "idx_banks_deleted_at" ON "banks" ("deleted_at");
-- create index "idx_organization_branch_bank" to table: "banks"
CREATE INDEX "idx_organization_branch_bank" ON "banks" ("organization_id", "branch_id");
-- create "revolving_funds" table
CREATE TABLE "revolving_funds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "beginning_balance" numeric(15,2) NULL DEFAULT 0,
  "revolving_fund_beginning_balance" numeric(15,2) NULL DEFAULT 0,
  "add_replenishment" numeric(15,2) NULL DEFAULT 0,
  "total" numeric(15,2) NULL DEFAULT 0,
  "total_less_disbursements" numeric(15,2) NULL DEFAULT 0,
  "withdrawals" numeric(15,2) NULL DEFAULT 0,
  "cash_advance" numeric(15,2) NULL DEFAULT 0,
  "revolving_fund_ending_total" numeric(15,2) NULL DEFAULT 0,
  "total_revolving_fund_countered" numeric(15,2) NULL DEFAULT 0,
  "total_check_remittance" numeric(15,2) NULL DEFAULT 0,
  "balance_status" character varying(50) NULL,
  "is_closed" boolean NULL DEFAULT false,
  "can_view" boolean NULL DEFAULT false,
  "request_view" boolean NOT NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_revolving_funds_account" FOREIGN KEY ("account_id") REFERENCES "banks" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_revolving_funds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_revolving_funds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_revolving_funds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_revolving_funds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_revolving_funds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_revolving_funds_branch_id" to table: "revolving_funds"
CREATE INDEX "idx_revolving_funds_branch_id" ON "revolving_funds" ("branch_id");
-- create index "idx_revolving_funds_deleted_at" to table: "revolving_funds"
CREATE INDEX "idx_revolving_funds_deleted_at" ON "revolving_funds" ("deleted_at");
-- create index "idx_revolving_funds_organization_id" to table: "revolving_funds"
CREATE INDEX "idx_revolving_funds_organization_id" ON "revolving_funds" ("organization_id");
-- create "branch_settings" table
CREATE TABLE "branch_settings" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "cash_on_hand_account_id" uuid NULL,
  "paid_up_shared_capital_account_id" uuid NULL,
  "compassion_fund_account_id" uuid NULL,
  "withdraw_allow_user_input" boolean NOT NULL DEFAULT true,
  "withdraw_prefix" character varying(50) NOT NULL DEFAULT 'WD',
  "withdraw_or_start" bigint NOT NULL DEFAULT 0,
  "withdraw_or_current" bigint NOT NULL DEFAULT 1,
  "withdraw_or_end" bigint NOT NULL DEFAULT 9999,
  "withdraw_or_iteration" bigint NOT NULL DEFAULT 1,
  "withdraw_use_date_or" boolean NOT NULL DEFAULT false,
  "withdraw_padding" bigint NOT NULL DEFAULT 6,
  "withdraw_common_or" character varying(100) NULL,
  "deposit_allow_user_input" boolean NOT NULL DEFAULT true,
  "deposit_or_start" bigint NOT NULL DEFAULT 0,
  "deposit_or_current" bigint NOT NULL DEFAULT 1,
  "deposit_or_end" bigint NOT NULL DEFAULT 9999,
  "deposit_or_iteration" bigint NOT NULL DEFAULT 1,
  "deposit_use_date_or" boolean NOT NULL DEFAULT false,
  "deposit_padding" bigint NOT NULL DEFAULT 6,
  "deposit_common_or" character varying(100) NULL,
  "cash_check_voucher_allow_user_input" boolean NOT NULL DEFAULT true,
  "cash_check_voucher_or_unique" boolean NOT NULL DEFAULT false,
  "cash_check_voucher_prefix" character varying(50) NOT NULL DEFAULT 'CCV',
  "cash_check_voucher_or_start" bigint NOT NULL DEFAULT 0,
  "cash_check_voucher_or_current" bigint NOT NULL DEFAULT 1,
  "cash_check_voucher_padding" bigint NOT NULL DEFAULT 6,
  "journal_voucher_allow_user_input" boolean NOT NULL DEFAULT true,
  "journal_voucher_or_unique" boolean NOT NULL DEFAULT false,
  "journal_voucher_prefix" character varying(50) NOT NULL DEFAULT 'JV',
  "journal_voucher_or_start" bigint NOT NULL DEFAULT 0,
  "journal_voucher_or_current" bigint NOT NULL DEFAULT 1,
  "journal_voucher_padding" bigint NOT NULL DEFAULT 6,
  "adjustment_voucher_allow_user_input" boolean NOT NULL DEFAULT true,
  "adjustment_voucher_or_unique" boolean NOT NULL DEFAULT false,
  "adjustment_voucher_prefix" character varying(50) NOT NULL DEFAULT 'AV',
  "adjustment_voucher_or_start" bigint NOT NULL DEFAULT 0,
  "adjustment_voucher_or_current" bigint NOT NULL DEFAULT 1,
  "adjustment_voucher_padding" bigint NOT NULL DEFAULT 6,
  "loan_voucher_allow_user_input" boolean NOT NULL DEFAULT true,
  "loan_voucher_or_unique" boolean NOT NULL DEFAULT false,
  "loan_voucher_prefix" character varying(50) NOT NULL DEFAULT 'LV',
  "loan_voucher_or_start" bigint NOT NULL DEFAULT 0,
  "loan_voucher_or_current" bigint NOT NULL DEFAULT 1,
  "loan_voucher_padding" bigint NOT NULL DEFAULT 6,
  "check_voucher_general" boolean NOT NULL DEFAULT false,
  "check_voucher_general_allow_user_input" boolean NOT NULL DEFAULT true,
  "check_voucher_general_or_unique" boolean NOT NULL DEFAULT false,
  "check_voucher_general_prefix" character varying(50) NOT NULL DEFAULT 'CV',
  "check_voucher_general_or_start" bigint NOT NULL DEFAULT 0,
  "check_voucher_general_or_current" bigint NOT NULL DEFAULT 1,
  "check_voucher_general_padding" bigint NOT NULL DEFAULT 6,
  "tax_interest" numeric NOT NULL DEFAULT 0,
  "default_member_gender_id" uuid NULL,
  "default_member_type_id" uuid NULL,
  "loan_applied_equal_to_balance" boolean NOT NULL DEFAULT false,
  "annual_divisor" bigint NOT NULL DEFAULT 360,
  "account_wallet_id" uuid NULL,
  "revolving_fund_account_id" uuid NULL,
  "member_profile_passbook_allow_user_input" boolean NOT NULL DEFAULT true,
  "member_profile_passbook_or_unique" boolean NOT NULL DEFAULT false,
  "member_profile_passbook_prefix" character varying(50) NOT NULL DEFAULT '',
  "member_profile_passbook_or_start" bigint NOT NULL DEFAULT 0,
  "member_profile_passbook_or_current" bigint NOT NULL DEFAULT 1,
  "member_profile_passbook_padding" bigint NOT NULL DEFAULT 6,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branch_settings_account_wallet" FOREIGN KEY ("account_wallet_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_cash_on_hand_account" FOREIGN KEY ("cash_on_hand_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_compassion_fund_account" FOREIGN KEY ("compassion_fund_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_branch_settings_default_member_gender" FOREIGN KEY ("default_member_gender_id") REFERENCES "member_genders" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_default_member_type" FOREIGN KEY ("default_member_type_id") REFERENCES "member_types" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_paid_up_shared_capital_account" FOREIGN KEY ("paid_up_shared_capital_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branch_settings_revolving_fund_account" FOREIGN KEY ("revolving_fund_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_branches_branch_setting" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_branch_settings_branch_id" to table: "branch_settings"
CREATE UNIQUE INDEX "idx_branch_settings_branch_id" ON "branch_settings" ("branch_id");
-- create index "idx_branch_settings_deleted_at" to table: "branch_settings"
CREATE INDEX "idx_branch_settings_deleted_at" ON "branch_settings" ("deleted_at");
-- create "unbalanced_accounts" table
CREATE TABLE "unbalanced_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "branch_settings_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "account_for_shortage_id" uuid NOT NULL,
  "account_for_overage_id" uuid NOT NULL,
  "member_profile_id_for_shortage" uuid NULL,
  "member_profile_id_for_overage" uuid NULL,
  "cash_on_hand_account_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branch_settings_unbalanced_accounts" FOREIGN KEY ("branch_settings_id") REFERENCES "branch_settings" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_unbalanced_accounts_account_for_overage" FOREIGN KEY ("account_for_overage_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_unbalanced_accounts_account_for_shortage" FOREIGN KEY ("account_for_shortage_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_unbalanced_accounts_cash_on_hand_account" FOREIGN KEY ("cash_on_hand_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_unbalanced_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_unbalanced_accounts_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_unbalanced_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_unbalanced_accounts_member_profile_for_overage" FOREIGN KEY ("member_profile_id_for_overage") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_unbalanced_accounts_member_profile_for_shortage" FOREIGN KEY ("member_profile_id_for_shortage") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_unbalanced_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_unbalanced_accounts_deleted_at" to table: "unbalanced_accounts"
CREATE INDEX "idx_unbalanced_accounts_deleted_at" ON "unbalanced_accounts" ("deleted_at");
-- create index "idx_unique_currency_per_branch_settings" to table: "unbalanced_accounts"
CREATE UNIQUE INDEX "idx_unique_currency_per_branch_settings" ON "unbalanced_accounts" ("currency_id", "branch_settings_id");
-- create "transaction_batches" table
CREATE TABLE "transaction_batches" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "employee_user_id" uuid NULL,
  "batch_name" character varying(50) NULL,
  "total_cash_collection" numeric NULL,
  "total_deposit_entry" numeric NULL,
  "beginning_balance" numeric NULL,
  "deposit_in_bank" numeric NULL,
  "cash_count_total" numeric NULL,
  "grand_total" numeric NULL,
  "petty_cash" numeric NULL,
  "loan_releases" numeric NULL,
  "cash_check_voucher_total" numeric NULL,
  "time_deposit_withdrawal" numeric NULL,
  "savings_withdrawal" numeric NULL,
  "total_cash_handled" numeric NULL,
  "total_supposed_remmitance" numeric NULL,
  "total_cash_on_hand" numeric NULL,
  "total_check_remittance" numeric NULL,
  "total_online_remittance" numeric NULL,
  "total_deposit_in_bank" numeric NULL,
  "total_actual_remittance" numeric NULL,
  "total_actual_supposed_comparison" numeric NULL,
  "description" text NULL,
  "can_view" boolean NOT NULL DEFAULT false,
  "is_closed" boolean NOT NULL DEFAULT false,
  "request_view" boolean NOT NULL DEFAULT false,
  "employee_by_signature_media_id" uuid NULL,
  "employee_by_name" character varying(255) NULL,
  "employee_by_position" character varying(255) NULL,
  "approved_by_signature_media_id" uuid NULL,
  "approved_by_name" character varying(255) NULL,
  "approved_by_position" character varying(255) NULL,
  "prepared_by_signature_media_id" uuid NULL,
  "prepared_by_name" character varying(255) NULL,
  "prepared_by_position" character varying(255) NULL,
  "certified_by_signature_media_id" uuid NULL,
  "certified_by_name" character varying(255) NULL,
  "certified_by_position" character varying(255) NULL,
  "verified_by_signature_media_id" uuid NULL,
  "verified_by_name" character varying(255) NULL,
  "verified_by_position" character varying(255) NULL,
  "check_by_signature_media_id" uuid NULL,
  "check_by_name" character varying(255) NULL,
  "check_by_position" character varying(255) NULL,
  "acknowledge_by_signature_media_id" uuid NULL,
  "acknowledge_by_name" character varying(255) NULL,
  "acknowledge_by_position" character varying(255) NULL,
  "noted_by_signature_media_id" uuid NULL,
  "noted_by_name" character varying(255) NULL,
  "noted_by_position" character varying(255) NULL,
  "posted_by_signature_media_id" uuid NULL,
  "posted_by_name" character varying(255) NULL,
  "posted_by_position" character varying(255) NULL,
  "paid_by_signature_media_id" uuid NULL,
  "paid_by_name" character varying(255) NULL,
  "paid_by_position" character varying(255) NULL,
  "currency_id" uuid NOT NULL,
  "ended_at" timestamp NULL,
  "unbalanced_account_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_transaction_batches_acknowledge_by_signature_media" FOREIGN KEY ("acknowledge_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_approved_by_signature_media" FOREIGN KEY ("approved_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transaction_batches_certified_by_signature_media" FOREIGN KEY ("certified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_check_by_signature_media" FOREIGN KEY ("check_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transaction_batches_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transaction_batches_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transaction_batches_employee_by_signature_media" FOREIGN KEY ("employee_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_noted_by_signature_media" FOREIGN KEY ("noted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transaction_batches_paid_by_signature_media" FOREIGN KEY ("paid_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_posted_by_signature_media" FOREIGN KEY ("posted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_prepared_by_signature_media" FOREIGN KEY ("prepared_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_transaction_batches_unbalanced_account" FOREIGN KEY ("unbalanced_account_id") REFERENCES "unbalanced_accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transaction_batches_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transaction_batches_verified_by_signature_media" FOREIGN KEY ("verified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_organization_branch_transaction_batch" to table: "transaction_batches"
CREATE INDEX "idx_organization_branch_transaction_batch" ON "transaction_batches" ("organization_id", "branch_id");
-- create index "idx_transaction_batches_deleted_at" to table: "transaction_batches"
CREATE INDEX "idx_transaction_batches_deleted_at" ON "transaction_batches" ("deleted_at");
-- create "loan_transactions" table
CREATE TABLE "loan_transactions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "official_receipt_number" character varying(255) NULL,
  "check_number" character varying(255) NULL,
  "check_date" timestamp NULL,
  "voucher" character varying(255) NULL,
  "loan_purpose_id" uuid NULL,
  "loan_status_id" uuid NULL,
  "mode_of_payment" character varying(255) NULL,
  "mode_of_payment_weekly" character varying(255) NULL,
  "mode_of_payment_semi_monthly_pay1" bigint NULL,
  "mode_of_payment_semi_monthly_pay2" bigint NULL,
  "mode_of_payment_fixed_days" bigint NULL DEFAULT 0,
  "mode_of_payment_monthly_exact_day" boolean NULL DEFAULT false,
  "comaker_type" character varying(255) NULL,
  "comaker_deposit_member_accounting_ledger_id" uuid NULL,
  "collector_place" character varying(255) NULL DEFAULT 'office',
  "loan_type" character varying(255) NULL DEFAULT 'standard',
  "previous_loan_id" uuid NULL,
  "terms" bigint NOT NULL,
  "amortization" numeric NULL,
  "is_add_on" boolean NULL,
  "applied1" numeric NOT NULL,
  "applied2" numeric NULL,
  "account_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "member_joint_account_id" uuid NULL,
  "signature_media_id" uuid NULL,
  "mount_to_be_closed" numeric NULL,
  "damayan_fund" numeric NULL,
  "share_capital" numeric NULL,
  "length_of_service" character varying(255) NULL,
  "exclude_sunday" boolean NULL DEFAULT false,
  "exclude_holiday" boolean NULL DEFAULT false,
  "exclude_saturday" boolean NULL DEFAULT false,
  "remarks_other_terms" text NULL,
  "remarks_payroll_deduction" boolean NULL DEFAULT false,
  "record_of_loan_payments_or_loan_status" character varying(255) NULL,
  "collateral_offered" text NULL,
  "appraised_value" numeric NULL,
  "appraised_value_description" text NULL,
  "printed_date" timestamp NULL,
  "approved_date" timestamp NULL,
  "released_date" timestamp NULL,
  "print_number" bigint NULL DEFAULT 0,
  "released_by_id" uuid NULL,
  "printed_by_id" uuid NULL,
  "approved_by_id" uuid NULL,
  "approved_by_signature_media_id" uuid NULL,
  "approved_by_name" character varying(255) NULL,
  "approved_by_position" character varying(255) NULL,
  "prepared_by_signature_media_id" uuid NULL,
  "prepared_by_name" character varying(255) NULL,
  "prepared_by_position" character varying(255) NULL,
  "certified_by_signature_media_id" uuid NULL,
  "certified_by_name" character varying(255) NULL,
  "certified_by_position" character varying(255) NULL,
  "verified_by_signature_media_id" uuid NULL,
  "verified_by_name" character varying(255) NULL,
  "verified_by_position" character varying(255) NULL,
  "check_by_signature_media_id" uuid NULL,
  "check_by_name" character varying(255) NULL,
  "check_by_position" character varying(255) NULL,
  "acknowledge_by_signature_media_id" uuid NULL,
  "acknowledge_by_name" character varying(255) NULL,
  "acknowledge_by_position" character varying(255) NULL,
  "noted_by_signature_media_id" uuid NULL,
  "noted_by_name" character varying(255) NULL,
  "noted_by_position" character varying(255) NULL,
  "posted_by_signature_media_id" uuid NULL,
  "posted_by_name" character varying(255) NULL,
  "posted_by_position" character varying(255) NULL,
  "paid_by_signature_media_id" uuid NULL,
  "paid_by_name" character varying(255) NULL,
  "paid_by_position" character varying(255) NULL,
  "count" bigint NULL DEFAULT 0,
  "balance" numeric NULL DEFAULT 0,
  "last_pay" timestamp NULL,
  "fines" numeric NULL DEFAULT 0,
  "interest" numeric NULL DEFAULT 0,
  "total_debit" numeric NULL DEFAULT 0,
  "total_credit" numeric NULL DEFAULT 0,
  "total_principal" numeric NULL DEFAULT 0,
  "total_add_on" numeric NULL DEFAULT 0,
  "amount_granted" numeric NULL DEFAULT 0,
  "processing" boolean NULL DEFAULT false,
  "revolving_fund_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_transactions_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_acknowledge_by_signature_media" FOREIGN KEY ("acknowledge_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_approved_by" FOREIGN KEY ("approved_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_approved_by_signature_media" FOREIGN KEY ("approved_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_transactions_certified_by_signature_media" FOREIGN KEY ("certified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_check_by_signature_media" FOREIGN KEY ("check_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_comaker_deposit_member_accounting_ledger" FOREIGN KEY ("comaker_deposit_member_accounting_ledger_id") REFERENCES "member_accounting_ledgers" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_loan_purpose" FOREIGN KEY ("loan_purpose_id") REFERENCES "loan_purposes" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_loan_status" FOREIGN KEY ("loan_status_id") REFERENCES "loan_statuses" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_member_joint_account" FOREIGN KEY ("member_joint_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_noted_by_signature_media" FOREIGN KEY ("noted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_transactions_paid_by_signature_media" FOREIGN KEY ("paid_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_posted_by_signature_media" FOREIGN KEY ("posted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_prepared_by_signature_media" FOREIGN KEY ("prepared_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_previous_loan" FOREIGN KEY ("previous_loan_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_printed_by" FOREIGN KEY ("printed_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_released_by" FOREIGN KEY ("released_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_revolving_fund" FOREIGN KEY ("revolving_fund_id") REFERENCES "revolving_funds" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_transactions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_verified_by_signature_media" FOREIGN KEY ("verified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_transactions_deleted_at" to table: "loan_transactions"
CREATE INDEX "idx_loan_transactions_deleted_at" ON "loan_transactions" ("deleted_at");
-- create index "idx_organization_branch_loan_transaction" to table: "loan_transactions"
CREATE INDEX "idx_organization_branch_loan_transaction" ON "loan_transactions" ("organization_id", "branch_id");
-- create "payment_types" table
CREATE TABLE "payment_types" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "number_of_days" bigint NULL,
  "type" character varying(20) NULL,
  "account_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_payment_types_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_payment_types_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_payment_types_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_payment_types_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_payment_types_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_payment_types_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_payment_type" to table: "payment_types"
CREATE INDEX "idx_organization_branch_payment_type" ON "payment_types" ("organization_id");
-- create index "idx_organization_branch_peyment_type" to table: "payment_types"
CREATE INDEX "idx_organization_branch_peyment_type" ON "payment_types" ("branch_id");
-- create index "idx_payment_types_deleted_at" to table: "payment_types"
CREATE INDEX "idx_payment_types_deleted_at" ON "payment_types" ("deleted_at");
-- create "adjustment_entries" table
CREATE TABLE "adjustment_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "transaction_batch_id" uuid NULL,
  "signature_media_id" uuid NULL,
  "account_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "payment_type_id" uuid NULL,
  "type_of_payment_type" character varying(50) NULL,
  "description" text NULL,
  "reference_number" character varying(255) NULL,
  "entry_date" date NULL,
  "debit" numeric NULL,
  "credit" numeric NULL,
  "loan_transaction_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_adjustment_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_adjustment_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_adjustment_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_entries_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_adjustment_entries_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_adjustment_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_adjustment_entries_payment_type" FOREIGN KEY ("payment_type_id") REFERENCES "payment_types" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_adjustment_entries_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_entries_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_adjustment_entries_deleted_at" to table: "adjustment_entries"
CREATE INDEX "idx_adjustment_entries_deleted_at" ON "adjustment_entries" ("deleted_at");
-- create index "idx_organization_branch_adjustment_entry" to table: "adjustment_entries"
CREATE INDEX "idx_organization_branch_adjustment_entry" ON "adjustment_entries" ("organization_id", "branch_id");
-- create "adjustment_tags" table
CREATE TABLE "adjustment_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "adjustment_entry_id" uuid NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_adjustment_entries_adjustment_tags" FOREIGN KEY ("adjustment_entry_id") REFERENCES "adjustment_entries" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_adjustment_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_adjustment_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_adjustment_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_adjustment_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_adjustment_tags_deleted_at" to table: "adjustment_tags"
CREATE INDEX "idx_adjustment_tags_deleted_at" ON "adjustment_tags" ("deleted_at");
-- create index "idx_organization_branch_adjustment_entry_tag" to table: "adjustment_tags"
CREATE INDEX "idx_organization_branch_adjustment_entry_tag" ON "adjustment_tags" ("organization_id", "branch_id");
-- create "areas" table
CREATE TABLE "areas" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "latitude" numeric(10,7) NULL,
  "longitude" numeric(10,7) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_areas_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_areas_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_areas_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_areas_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_areas_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_areas_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_areas_deleted_at" to table: "areas"
CREATE INDEX "idx_areas_deleted_at" ON "areas" ("deleted_at");
-- create index "idx_organization_branch_area" to table: "areas"
CREATE INDEX "idx_organization_branch_area" ON "areas" ("organization_id", "branch_id");
-- create "charges_rate_schemes" table
CREATE TABLE "charges_rate_schemes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" character varying(255) NULL DEFAULT '',
  "icon" character varying(255) NULL,
  "type" character varying(50) NOT NULL,
  "member_type_id" uuid NULL,
  "mode_of_payment" character varying(20) NULL,
  "mode_of_payment_header1" bigint NULL DEFAULT 0,
  "mode_of_payment_header2" bigint NULL DEFAULT 0,
  "mode_of_payment_header3" bigint NULL DEFAULT 0,
  "mode_of_payment_header4" bigint NULL DEFAULT 0,
  "mode_of_payment_header5" bigint NULL DEFAULT 0,
  "mode_of_payment_header6" bigint NULL DEFAULT 0,
  "mode_of_payment_header7" bigint NULL DEFAULT 0,
  "mode_of_payment_header8" bigint NULL DEFAULT 0,
  "mode_of_payment_header9" bigint NULL DEFAULT 0,
  "mode_of_payment_header10" bigint NULL DEFAULT 0,
  "mode_of_payment_header11" bigint NULL DEFAULT 0,
  "mode_of_payment_header12" bigint NULL DEFAULT 0,
  "mode_of_payment_header13" bigint NULL DEFAULT 0,
  "mode_of_payment_header14" bigint NULL DEFAULT 0,
  "mode_of_payment_header15" bigint NULL DEFAULT 0,
  "mode_of_payment_header16" bigint NULL DEFAULT 0,
  "mode_of_payment_header17" bigint NULL DEFAULT 0,
  "mode_of_payment_header18" bigint NULL DEFAULT 0,
  "mode_of_payment_header19" bigint NULL DEFAULT 0,
  "mode_of_payment_header20" bigint NULL DEFAULT 0,
  "mode_of_payment_header21" bigint NULL DEFAULT 0,
  "mode_of_payment_header22" bigint NULL DEFAULT 0,
  "by_term_header1" bigint NULL DEFAULT 0,
  "by_term_header2" bigint NULL DEFAULT 0,
  "by_term_header3" bigint NULL DEFAULT 0,
  "by_term_header4" bigint NULL DEFAULT 0,
  "by_term_header5" bigint NULL DEFAULT 0,
  "by_term_header6" bigint NULL DEFAULT 0,
  "by_term_header7" bigint NULL DEFAULT 0,
  "by_term_header8" bigint NULL DEFAULT 0,
  "by_term_header9" bigint NULL DEFAULT 0,
  "by_term_header10" bigint NULL DEFAULT 0,
  "by_term_header11" bigint NULL DEFAULT 0,
  "by_term_header12" bigint NULL DEFAULT 0,
  "by_term_header13" bigint NULL DEFAULT 0,
  "by_term_header14" bigint NULL DEFAULT 0,
  "by_term_header15" bigint NULL DEFAULT 0,
  "by_term_header16" bigint NULL DEFAULT 0,
  "by_term_header17" bigint NULL DEFAULT 0,
  "by_term_header18" bigint NULL DEFAULT 0,
  "by_term_header19" bigint NULL DEFAULT 0,
  "by_term_header20" bigint NULL DEFAULT 0,
  "by_term_header21" bigint NULL DEFAULT 0,
  "by_term_header22" bigint NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_charges_rate_schemes_name" UNIQUE ("name"),
  CONSTRAINT "fk_charges_rate_schemes_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_schemes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_schemes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_charges_rate_schemes_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_schemes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_charges_rate_schemes_deleted_at" to table: "charges_rate_schemes"
CREATE INDEX "idx_charges_rate_schemes_deleted_at" ON "charges_rate_schemes" ("deleted_at");
-- create index "idx_organization_branch_charges_rate_scheme" to table: "charges_rate_schemes"
CREATE INDEX "idx_organization_branch_charges_rate_scheme" ON "charges_rate_schemes" ("organization_id", "branch_id");
-- create "automatic_loan_deductions" table
CREATE TABLE "automatic_loan_deductions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "computation_sheet_id" uuid NULL,
  "charges_rate_scheme_id" uuid NULL,
  "charges_percentage1" numeric NULL,
  "charges_percentage2" numeric NULL,
  "charges_amount" numeric NULL,
  "charges_divisor" numeric NULL,
  "min_amount" numeric NULL,
  "max_amount" numeric NULL,
  "anum" smallint NULL DEFAULT 0,
  "number_of_months" bigint NULL,
  "add_on" boolean NULL DEFAULT false,
  "ao_rest" boolean NULL DEFAULT false,
  "exclude_renewal" boolean NULL DEFAULT false,
  "ct" bigint NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_automatic_loan_deductions_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_automatic_loan_deductions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_automatic_loan_deductions_charges_rate_scheme" FOREIGN KEY ("charges_rate_scheme_id") REFERENCES "charges_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_automatic_loan_deductions_computation_sheet" FOREIGN KEY ("computation_sheet_id") REFERENCES "computation_sheets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_automatic_loan_deductions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_automatic_loan_deductions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_automatic_loan_deductions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_automatic_loan_deductions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_automatic_loan_deductions_deleted_at" to table: "automatic_loan_deductions"
CREATE INDEX "idx_automatic_loan_deductions_deleted_at" ON "automatic_loan_deductions" ("deleted_at");
-- create index "idx_organization_branch_automatic_loan_deduction" to table: "automatic_loan_deductions"
CREATE INDEX "idx_organization_branch_automatic_loan_deduction" ON "automatic_loan_deductions" ("organization_id", "branch_id");
-- create "batch_fundings" table
CREATE TABLE "batch_fundings" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "transaction_batch_id" uuid NOT NULL,
  "provided_by_user_id" uuid NOT NULL,
  "signature_media_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "amount" numeric NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_batch_fundings_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_batch_fundings_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_batch_fundings_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_batch_fundings_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_batch_fundings_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_batch_fundings_provided_by_user" FOREIGN KEY ("provided_by_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_batch_fundings_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_batch_fundings_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_batch_fundings_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_batch_fundings_deleted_at" to table: "batch_fundings"
CREATE INDEX "idx_batch_fundings_deleted_at" ON "batch_fundings" ("deleted_at");
-- create index "idx_organization_branch_batch_funding" to table: "batch_fundings"
CREATE INDEX "idx_organization_branch_batch_funding" ON "batch_fundings" ("organization_id", "branch_id");
-- create "bill_and_coins" table
CREATE TABLE "bill_and_coins" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "value" numeric NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_bill_and_coins_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_bill_and_coins_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_bill_and_coins_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_bill_and_coins_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_bill_and_coins_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_bill_and_coins_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_bill_and_coins_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_bill_and_coins_deleted_at" to table: "bill_and_coins"
CREATE INDEX "idx_bill_and_coins_deleted_at" ON "bill_and_coins" ("deleted_at");
-- create index "idx_organization_branch_bill_and_coins" to table: "bill_and_coins"
CREATE INDEX "idx_organization_branch_bill_and_coins" ON "bill_and_coins" ("organization_id", "branch_id");
-- create index "idx_unique_name_org_branch" to table: "bill_and_coins"
CREATE UNIQUE INDEX "idx_unique_name_org_branch" ON "bill_and_coins" ("organization_id", "branch_id", "name");
-- create "browse_exclude_include_accounts" table
CREATE TABLE "browse_exclude_include_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "computation_sheet_id" uuid NULL,
  "fines_account_id" uuid NULL,
  "comaker_account_id" uuid NULL,
  "interest_account_id" uuid NULL,
  "deliquent_account_id" uuid NULL,
  "include_existing_loan_account_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_browse_exclude_include_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_browse_exclude_include_accounts_comaker_account" FOREIGN KEY ("comaker_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_computation_sheet" FOREIGN KEY ("computation_sheet_id") REFERENCES "computation_sheets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_browse_exclude_include_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_browse_exclude_include_accounts_deliquent_account" FOREIGN KEY ("deliquent_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_fines_account" FOREIGN KEY ("fines_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_include_existing_loan_accoun" FOREIGN KEY ("include_existing_loan_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_interest_account" FOREIGN KEY ("interest_account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_browse_exclude_include_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_browse_exclude_include_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_browse_exclude_include_accounts_deleted_at" to table: "browse_exclude_include_accounts"
CREATE INDEX "idx_browse_exclude_include_accounts_deleted_at" ON "browse_exclude_include_accounts" ("deleted_at");
-- create index "idx_organization_branch_browse_exclude_include_accounts" to table: "browse_exclude_include_accounts"
CREATE INDEX "idx_organization_branch_browse_exclude_include_accounts" ON "browse_exclude_include_accounts" ("organization_id", "branch_id");
-- create "browse_references" table
CREATE TABLE "browse_references" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "interest_rate" numeric(15,6) NULL DEFAULT 0,
  "minimum_balance" numeric(15,2) NULL DEFAULT 0,
  "charges" numeric(15,2) NULL DEFAULT 0,
  "account_id" uuid NULL,
  "member_type_id" uuid NULL,
  "interest_type" character varying(20) NOT NULL DEFAULT 'year',
  "default_minimum_balance" numeric(15,2) NULL DEFAULT 0,
  "default_interest_rate" numeric(15,6) NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_browse_references_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_browse_references_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_browse_references_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_browse_references_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_browse_references_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_browse_references_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_types_browse_references" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_browse_references_deleted_at" to table: "browse_references"
CREATE INDEX "idx_browse_references_deleted_at" ON "browse_references" ("deleted_at");
-- create index "idx_organization_branch_browse_reference" to table: "browse_references"
CREATE INDEX "idx_organization_branch_browse_reference" ON "browse_references" ("organization_id", "branch_id");
-- create "cancelled_cash_check_vouchers" table
CREATE TABLE "cancelled_cash_check_vouchers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "check_number" character varying(255) NOT NULL,
  "entry_date" timestamptz NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cancelled_cash_check_vouchers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cancelled_cash_check_vouchers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cancelled_cash_check_vouchers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cancelled_cash_check_vouchers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cancelled_cash_check_vouchers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cancelled_cash_check_vouchers_deleted_at" to table: "cancelled_cash_check_vouchers"
CREATE INDEX "idx_cancelled_cash_check_vouchers_deleted_at" ON "cancelled_cash_check_vouchers" ("deleted_at");
-- create index "idx_organization_branch_cancelled_cash_check_voucher" to table: "cancelled_cash_check_vouchers"
CREATE INDEX "idx_organization_branch_cancelled_cash_check_voucher" ON "cancelled_cash_check_vouchers" ("organization_id", "branch_id");
-- create "cash_check_vouchers" table
CREATE TABLE "cash_check_vouchers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "name" character varying(255) NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "printed_by_id" uuid NULL,
  "approved_by_id" uuid NULL,
  "released_by_id" uuid NULL,
  "pay_to" character varying(255) NULL,
  "status" character varying(20) NULL,
  "description" text NULL,
  "cash_voucher_number" character varying(255) NULL DEFAULT '',
  "total_debit" numeric NULL,
  "total_credit" numeric NULL,
  "print_count" bigint NULL DEFAULT 0,
  "entry_date" timestamptz NULL,
  "printed_date" timestamptz NULL,
  "approved_date" timestamptz NULL,
  "released_date" timestamptz NULL,
  "approved_by_signature_media_id" uuid NULL,
  "approved_by_name" character varying(255) NULL,
  "approved_by_position" character varying(255) NULL,
  "prepared_by_signature_media_id" uuid NULL,
  "prepared_by_name" character varying(255) NULL,
  "prepared_by_position" character varying(255) NULL,
  "certified_by_signature_media_id" uuid NULL,
  "certified_by_name" character varying(255) NULL,
  "certified_by_position" character varying(255) NULL,
  "verified_by_signature_media_id" uuid NULL,
  "verified_by_name" character varying(255) NULL,
  "verified_by_position" character varying(255) NULL,
  "check_by_signature_media_id" uuid NULL,
  "check_by_name" character varying(255) NULL,
  "check_by_position" character varying(255) NULL,
  "acknowledge_by_signature_media_id" uuid NULL,
  "acknowledge_by_name" character varying(255) NULL,
  "acknowledge_by_position" character varying(255) NULL,
  "noted_by_signature_media_id" uuid NULL,
  "noted_by_name" character varying(255) NULL,
  "noted_by_position" character varying(255) NULL,
  "posted_by_signature_media_id" uuid NULL,
  "posted_by_name" character varying(255) NULL,
  "posted_by_position" character varying(255) NULL,
  "paid_by_signature_media_id" uuid NULL,
  "paid_by_name" character varying(255) NULL,
  "paid_by_position" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_check_vouchers_acknowledge_by_signature_media" FOREIGN KEY ("acknowledge_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_approved_by" FOREIGN KEY ("approved_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_vouchers_approved_by_signature_media" FOREIGN KEY ("approved_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_vouchers_certified_by_signature_media" FOREIGN KEY ("certified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_check_by_signature_media" FOREIGN KEY ("check_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_vouchers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_vouchers_noted_by_signature_media" FOREIGN KEY ("noted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_vouchers_paid_by_signature_media" FOREIGN KEY ("paid_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_posted_by_signature_media" FOREIGN KEY ("posted_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_prepared_by_signature_media" FOREIGN KEY ("prepared_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_printed_by" FOREIGN KEY ("printed_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_vouchers_released_by" FOREIGN KEY ("released_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_vouchers_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_vouchers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_verified_by_signature_media" FOREIGN KEY ("verified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_check_vouchers_deleted_at" to table: "cash_check_vouchers"
CREATE INDEX "idx_cash_check_vouchers_deleted_at" ON "cash_check_vouchers" ("deleted_at");
-- create index "idx_organization_branch_cash_check_voucher" to table: "cash_check_vouchers"
CREATE INDEX "idx_organization_branch_cash_check_voucher" ON "cash_check_vouchers" ("organization_id", "branch_id");
-- create "cash_check_voucher_entries" table
CREATE TABLE "cash_check_voucher_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "cash_check_voucher_id" uuid NOT NULL,
  "loan_transaction_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "debit" numeric NULL,
  "credit" numeric NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_check_voucher_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_voucher_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_voucher_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_voucher_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_voucher_entries_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_voucher_entries_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_voucher_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_voucher_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_voucher_entries_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_check_voucher_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_cash_check_voucher_entries" FOREIGN KEY ("cash_check_voucher_id") REFERENCES "cash_check_vouchers" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_cash_check_voucher_entries_deleted_at" to table: "cash_check_voucher_entries"
CREATE INDEX "idx_cash_check_voucher_entries_deleted_at" ON "cash_check_voucher_entries" ("deleted_at");
-- create index "idx_organization_branch_cash_check_voucher_entry" to table: "cash_check_voucher_entries"
CREATE INDEX "idx_organization_branch_cash_check_voucher_entry" ON "cash_check_voucher_entries" ("organization_id", "branch_id");
-- create "cash_check_voucher_tags" table
CREATE TABLE "cash_check_voucher_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "cash_check_voucher_id" uuid NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_check_voucher_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_voucher_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_voucher_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_voucher_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_check_voucher_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_check_vouchers_cash_check_voucher_tags" FOREIGN KEY ("cash_check_voucher_id") REFERENCES "cash_check_vouchers" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_cash_check_voucher_tags_deleted_at" to table: "cash_check_voucher_tags"
CREATE INDEX "idx_cash_check_voucher_tags_deleted_at" ON "cash_check_voucher_tags" ("deleted_at");
-- create index "idx_organization_branch_cash_check_voucher_tag" to table: "cash_check_voucher_tags"
CREATE INDEX "idx_organization_branch_cash_check_voucher_tag" ON "cash_check_voucher_tags" ("organization_id", "branch_id");
-- create "cash_counts" table
CREATE TABLE "cash_counts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "employee_user_id" uuid NOT NULL,
  "transaction_batch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(100) NOT NULL,
  "bill_amount" numeric NULL,
  "quantity" bigint NULL,
  "amount" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_counts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_counts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_counts_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_counts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_counts_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_counts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_counts_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_counts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_counts_deleted_at" to table: "cash_counts"
CREATE INDEX "idx_cash_counts_deleted_at" ON "cash_counts" ("deleted_at");
-- create index "idx_organization_branch_cash_count" to table: "cash_counts"
CREATE INDEX "idx_organization_branch_cash_count" ON "cash_counts" ("organization_id", "branch_id");
-- create "cash_position_entries" table
CREATE TABLE "cash_position_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "entry_date" date NOT NULL,
  "reference_no" character varying(50) NULL,
  "description" text NULL,
  "beginning_balance" numeric NULL,
  "total_cash_in" numeric NULL,
  "total_cash_out" numeric NULL,
  "total_collections" numeric NULL,
  "total_disbursements" numeric NULL,
  "total_bank_deposits" numeric NULL,
  "total_petty_cash" numeric NULL,
  "ending_balance_calculated" numeric NULL,
  "actual_cash_on_hand" numeric NULL,
  "over_short_amount" numeric NULL,
  "is_closed" boolean NOT NULL DEFAULT false,
  "is_verified" boolean NOT NULL DEFAULT false,
  "prepared_by_name" character varying(255) NULL,
  "prepared_by_signature_media_id" uuid NULL,
  "verified_by_name" character varying(255) NULL,
  "verified_by_signature_media_id" uuid NULL,
  "approved_by_name" character varying(255) NULL,
  "approved_by_signature_media_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_position_entries_approved_by_signature_media" FOREIGN KEY ("approved_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_cash_position_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entries_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entries_prepared_by_signature_media" FOREIGN KEY ("prepared_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_cash_position_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entries_verified_by_signature_media" FOREIGN KEY ("verified_by_signature_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_cash_position_entries_deleted_at" to table: "cash_position_entries"
CREATE INDEX "idx_cash_position_entries_deleted_at" ON "cash_position_entries" ("deleted_at");
-- create index "idx_org_branch_cpe" to table: "cash_position_entries"
CREATE INDEX "idx_org_branch_cpe" ON "cash_position_entries" ("organization_id", "branch_id");
-- create "cash_position_entry_cash_counts" table
CREATE TABLE "cash_position_entry_cash_counts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "employee_user_id" uuid NOT NULL,
  "cash_position_entry_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(100) NOT NULL,
  "bill_amount" numeric NULL,
  "quantity" bigint NULL,
  "amount" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_position_entries_cash_counts" FOREIGN KEY ("cash_position_entry_id") REFERENCES "cash_position_entries" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_cash_counts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_cash_counts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_cash_counts_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_cash_counts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_cash_counts_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_cash_counts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_cash_counts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_position_entry_cash_counts_cash_position_entry_id" to table: "cash_position_entry_cash_counts"
CREATE INDEX "idx_cash_position_entry_cash_counts_cash_position_entry_id" ON "cash_position_entry_cash_counts" ("cash_position_entry_id");
-- create index "idx_cash_position_entry_cash_counts_deleted_at" to table: "cash_position_entry_cash_counts"
CREATE INDEX "idx_cash_position_entry_cash_counts_deleted_at" ON "cash_position_entry_cash_counts" ("deleted_at");
-- create index "idx_org_branch_cpe_cash_count" to table: "cash_position_entry_cash_counts"
CREATE INDEX "idx_org_branch_cpe_cash_count" ON "cash_position_entry_cash_counts" ("organization_id", "branch_id");
-- create "cash_position_entry_check_remittances" table
CREATE TABLE "cash_position_entry_check_remittances" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "cash_position_entry_id" uuid NOT NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "bank_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "reference_number" character varying(255) NULL,
  "account_name" character varying(255) NULL,
  "amount" numeric NOT NULL,
  "date_entry" timestamp NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_position_entries_check_remittances" FOREIGN KEY ("cash_position_entry_id") REFERENCES "cash_position_entries" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_check_remittances_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_check_remittances_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_check_remittances_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_check_remittances_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_check_remittances_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_check_remittances_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_check_remittances_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_check_remittances_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_check_remittances_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_check_remittances_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_position_entry_check_remittances_cash_positiona7184825" to table: "cash_position_entry_check_remittances"
CREATE INDEX "idx_cash_position_entry_check_remittances_cash_positiona7184825" ON "cash_position_entry_check_remittances" ("cash_position_entry_id");
-- create index "idx_cash_position_entry_check_remittances_deleted_at" to table: "cash_position_entry_check_remittances"
CREATE INDEX "idx_cash_position_entry_check_remittances_deleted_at" ON "cash_position_entry_check_remittances" ("deleted_at");
-- create index "idx_org_branch_cpe_check" to table: "cash_position_entry_check_remittances"
CREATE INDEX "idx_org_branch_cpe_check" ON "cash_position_entry_check_remittances" ("organization_id", "branch_id");
-- create "cash_position_entry_online_remittances" table
CREATE TABLE "cash_position_entry_online_remittances" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "cash_position_entry_id" uuid NOT NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "bank_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "reference_number" character varying(255) NULL,
  "amount" numeric NOT NULL,
  "account_name" character varying(255) NULL,
  "date_entry" timestamp NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_position_entries_online_remittances" FOREIGN KEY ("cash_position_entry_id") REFERENCES "cash_position_entries" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_online_remittances_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_online_remittances_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_online_remittances_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_online_remittances_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_online_remittances_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_online_remittances_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_online_remittances_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_cash_position_entry_online_remittances_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_online_remittances_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_cash_position_entry_online_remittances_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_position_entry_online_remittances_cash_positiobc03b300" to table: "cash_position_entry_online_remittances"
CREATE INDEX "idx_cash_position_entry_online_remittances_cash_positiobc03b300" ON "cash_position_entry_online_remittances" ("cash_position_entry_id");
-- create index "idx_cash_position_entry_online_remittances_deleted_at" to table: "cash_position_entry_online_remittances"
CREATE INDEX "idx_cash_position_entry_online_remittances_deleted_at" ON "cash_position_entry_online_remittances" ("deleted_at");
-- create index "idx_org_branch_cpe_online" to table: "cash_position_entry_online_remittances"
CREATE INDEX "idx_org_branch_cpe_online" ON "cash_position_entry_online_remittances" ("organization_id", "branch_id");
-- create "cash_position_entry_transaction_batches" table
CREATE TABLE "cash_position_entry_transaction_batches" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "cash_position_entry_id" uuid NOT NULL,
  "transaction_batch_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "employee_user_id" uuid NULL,
  "batch_name" character varying(50) NULL,
  "total_cash_collection" numeric NULL,
  "total_deposit_entry" numeric NULL,
  "beginning_balance" numeric NULL,
  "deposit_in_bank" numeric NULL,
  "cash_count_total" numeric NULL,
  "grand_total" numeric NULL,
  "petty_cash" numeric NULL,
  "loan_releases" numeric NULL,
  "cash_check_voucher_total" numeric NULL,
  "time_deposit_withdrawal" numeric NULL,
  "savings_withdrawal" numeric NULL,
  "total_cash_handled" numeric NULL,
  "total_supposed_remmitance" numeric NULL,
  "total_cash_on_hand" numeric NULL,
  "total_check_remittance" numeric NULL,
  "total_online_remittance" numeric NULL,
  "total_deposit_in_bank" numeric NULL,
  "total_actual_remittance" numeric NULL,
  "total_actual_supposed_comparison" numeric NULL,
  "description" text NULL,
  "is_closed" boolean NOT NULL DEFAULT false,
  "currency_id" uuid NOT NULL,
  "ended_at" timestamp NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_cash_position_entries_transaction_batches" FOREIGN KEY ("cash_position_entry_id") REFERENCES "cash_position_entries" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_cash_position_entry_transaction_batches_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_cash_position_entry_transaction_batches_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_cash_position_entry_transaction_batches_cash_positi348c4877" to table: "cash_position_entry_transaction_batches"
CREATE INDEX "idx_cash_position_entry_transaction_batches_cash_positi348c4877" ON "cash_position_entry_transaction_batches" ("cash_position_entry_id");
-- create index "idx_cash_position_entry_transaction_batches_deleted_at" to table: "cash_position_entry_transaction_batches"
CREATE INDEX "idx_cash_position_entry_transaction_batches_deleted_at" ON "cash_position_entry_transaction_batches" ("deleted_at");
-- create index "idx_org_branch_cpe_batch" to table: "cash_position_entry_transaction_batches"
CREATE INDEX "idx_org_branch_cpe_batch" ON "cash_position_entry_transaction_batches" ("organization_id", "branch_id");
-- create "charges_rate_by_range_or_minimum_amounts" table
CREATE TABLE "charges_rate_by_range_or_minimum_amounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "charges_rate_scheme_id" uuid NOT NULL,
  "from" numeric NULL DEFAULT 0,
  "to" numeric NULL DEFAULT 0,
  "charge" numeric NULL DEFAULT 0,
  "amount" numeric NULL DEFAULT 0,
  "minimum_amount" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_charges_rate_by_range_or_minimum_amounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_by_range_or_minimum_amounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_by_range_or_minimum_amounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_by_range_or_minimum_amounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_by_range_or_minimum_amounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_charges_rate_by_range_or_minimum_amount" FOREIGN KEY ("charges_rate_scheme_id") REFERENCES "charges_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_charges_rate_by_range_or_minimum_amounts_deleted_at" to table: "charges_rate_by_range_or_minimum_amounts"
CREATE INDEX "idx_charges_rate_by_range_or_minimum_amounts_deleted_at" ON "charges_rate_by_range_or_minimum_amounts" ("deleted_at");
-- create index "idx_organization_branch_charges_rate_by_range_or_minimum_amount" to table: "charges_rate_by_range_or_minimum_amounts"
CREATE INDEX "idx_organization_branch_charges_rate_by_range_or_minimum_amount" ON "charges_rate_by_range_or_minimum_amounts" ("organization_id", "branch_id");
-- create "charges_rate_by_terms" table
CREATE TABLE "charges_rate_by_terms" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "charges_rate_scheme_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "mode_of_payment" character varying(20) NULL DEFAULT 'monthly',
  "rate1" numeric NULL DEFAULT 0,
  "rate2" numeric NULL DEFAULT 0,
  "rate3" numeric NULL DEFAULT 0,
  "rate4" numeric NULL DEFAULT 0,
  "rate5" numeric NULL DEFAULT 0,
  "rate6" numeric NULL DEFAULT 0,
  "rate7" numeric NULL DEFAULT 0,
  "rate8" numeric NULL DEFAULT 0,
  "rate9" numeric NULL DEFAULT 0,
  "rate10" numeric NULL DEFAULT 0,
  "rate11" numeric NULL DEFAULT 0,
  "rate12" numeric NULL DEFAULT 0,
  "rate13" numeric NULL DEFAULT 0,
  "rate14" numeric NULL DEFAULT 0,
  "rate15" numeric NULL DEFAULT 0,
  "rate16" numeric NULL DEFAULT 0,
  "rate17" numeric NULL DEFAULT 0,
  "rate18" numeric NULL DEFAULT 0,
  "rate19" numeric NULL DEFAULT 0,
  "rate20" numeric NULL DEFAULT 0,
  "rate21" numeric NULL DEFAULT 0,
  "rate22" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_charges_rate_by_terms_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_by_terms_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_by_terms_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_by_terms_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_by_terms_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_charges_rate_by_terms" FOREIGN KEY ("charges_rate_scheme_id") REFERENCES "charges_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_charges_rate_by_terms_deleted_at" to table: "charges_rate_by_terms"
CREATE INDEX "idx_charges_rate_by_terms_deleted_at" ON "charges_rate_by_terms" ("deleted_at");
-- create index "idx_organization_branch_charges_rate_by_term" to table: "charges_rate_by_terms"
CREATE INDEX "idx_organization_branch_charges_rate_by_term" ON "charges_rate_by_terms" ("organization_id", "branch_id");
-- create "charges_rate_scheme_accounts" table
CREATE TABLE "charges_rate_scheme_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "charges_rate_scheme_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_charges_rate_scheme_accounts_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_charges_rate_scheme_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_scheme_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_scheme_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_scheme_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_scheme_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_charges_rate_scheme_accounts" FOREIGN KEY ("charges_rate_scheme_id") REFERENCES "charges_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_charges_rate_scheme_accounts_deleted_at" to table: "charges_rate_scheme_accounts"
CREATE INDEX "idx_charges_rate_scheme_accounts_deleted_at" ON "charges_rate_scheme_accounts" ("deleted_at");
-- create index "idx_organization_branch_charges_rate_scheme_account" to table: "charges_rate_scheme_accounts"
CREATE INDEX "idx_organization_branch_charges_rate_scheme_account" ON "charges_rate_scheme_accounts" ("organization_id", "branch_id");
-- create "charges_rate_scheme_mode_of_payments" table
CREATE TABLE "charges_rate_scheme_mode_of_payments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "charges_rate_scheme_id" uuid NOT NULL,
  "from" numeric NULL DEFAULT 0,
  "to" numeric NULL DEFAULT 0,
  "column1" numeric NULL DEFAULT 0,
  "column2" numeric NULL DEFAULT 0,
  "column3" numeric NULL DEFAULT 0,
  "column4" numeric NULL DEFAULT 0,
  "column5" numeric NULL DEFAULT 0,
  "column6" numeric NULL DEFAULT 0,
  "column7" numeric NULL DEFAULT 0,
  "column8" numeric NULL DEFAULT 0,
  "column9" numeric NULL DEFAULT 0,
  "column10" numeric NULL DEFAULT 0,
  "column11" numeric NULL DEFAULT 0,
  "column12" numeric NULL DEFAULT 0,
  "column13" numeric NULL DEFAULT 0,
  "column14" numeric NULL DEFAULT 0,
  "column15" numeric NULL DEFAULT 0,
  "column16" numeric NULL DEFAULT 0,
  "column17" numeric NULL DEFAULT 0,
  "column18" numeric NULL DEFAULT 0,
  "column19" numeric NULL DEFAULT 0,
  "column20" numeric NULL DEFAULT 0,
  "column21" numeric NULL DEFAULT 0,
  "column22" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_charges_rate_scheme_mode_of_payments_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_scheme_mode_of_payments_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_scheme_mode_of_payments_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_scheme_mode_of_payments_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_charges_rate_scheme_mode_of_payments_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_charges_rate_schemes_charges_rate_scheme_mode_of_payments" FOREIGN KEY ("charges_rate_scheme_id") REFERENCES "charges_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_charges_rate_scheme_mode_of_payments_deleted_at" to table: "charges_rate_scheme_mode_of_payments"
CREATE INDEX "idx_charges_rate_scheme_mode_of_payments_deleted_at" ON "charges_rate_scheme_mode_of_payments" ("deleted_at");
-- create index "idx_organization_branch_charges_rate_scheme_mode_of_payment" to table: "charges_rate_scheme_mode_of_payments"
CREATE INDEX "idx_organization_branch_charges_rate_scheme_mode_of_payment" ON "charges_rate_scheme_mode_of_payments" ("organization_id", "branch_id");
-- create "check_remittances" table
CREATE TABLE "check_remittances" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "bank_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "reference_number" character varying(255) NULL,
  "account_name" character varying(255) NULL,
  "amount" numeric NOT NULL,
  "date_entry" timestamp NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_check_remittances_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_check_remittances_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_check_remittances_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_remittances_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_check_remittances_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_remittances_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_check_remittances_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_remittances_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_check_remittances_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_check_remittances_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_check_remittances_deleted_at" to table: "check_remittances"
CREATE INDEX "idx_check_remittances_deleted_at" ON "check_remittances" ("deleted_at");
-- create index "idx_organization_branch_check_remittance" to table: "check_remittances"
CREATE INDEX "idx_organization_branch_check_remittance" ON "check_remittances" ("organization_id", "branch_id");
-- create "check_warehousings" table
CREATE TABLE "check_warehousings" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "bank_id" uuid NOT NULL,
  "employee_user_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "check_number" character varying(255) NOT NULL,
  "check_date" date NOT NULL,
  "clear_days" bigint NOT NULL DEFAULT 0,
  "date_cleared" date NULL,
  "amount" numeric(15,2) NOT NULL,
  "reference_number" character varying(255) NULL,
  "date" date NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_check_warehousings_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_check_warehousings_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_check_warehousings_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_warehousings_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_warehousings_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_warehousings_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_check_warehousings_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_check_warehousings_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_check_warehousings_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_check_warehousings_bank_id" to table: "check_warehousings"
CREATE INDEX "idx_check_warehousings_bank_id" ON "check_warehousings" ("bank_id");
-- create index "idx_check_warehousings_check_number" to table: "check_warehousings"
CREATE INDEX "idx_check_warehousings_check_number" ON "check_warehousings" ("check_number");
-- create index "idx_check_warehousings_deleted_at" to table: "check_warehousings"
CREATE INDEX "idx_check_warehousings_deleted_at" ON "check_warehousings" ("deleted_at");
-- create index "idx_check_warehousings_member_profile_id" to table: "check_warehousings"
CREATE INDEX "idx_check_warehousings_member_profile_id" ON "check_warehousings" ("member_profile_id");
-- create index "idx_check_warehousings_reference_number" to table: "check_warehousings"
CREATE INDEX "idx_check_warehousings_reference_number" ON "check_warehousings" ("reference_number");
-- create index "idx_org_branch_check" to table: "check_warehousings"
CREATE INDEX "idx_org_branch_check" ON "check_warehousings" ("organization_id", "branch_id");
-- create "collaterals" table
CREATE TABLE "collaterals" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "icon" character varying(255) NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_collaterals_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_collaterals_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_collaterals_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_collaterals_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_collaterals_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_collaterals_deleted_at" to table: "collaterals"
CREATE INDEX "idx_collaterals_deleted_at" ON "collaterals" ("deleted_at");
-- create index "idx_organization_branch_collateral" to table: "collaterals"
CREATE INDEX "idx_organization_branch_collateral" ON "collaterals" ("organization_id", "branch_id");
-- create "collectors_member_account_entries" table
CREATE TABLE "collectors_member_account_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "collector_user_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "account_id" uuid NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_collectors_member_account_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_collectors_member_account_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_collectors_member_account_entries_collector_user" FOREIGN KEY ("collector_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_collectors_member_account_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_collectors_member_account_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_collectors_member_account_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_collectors_member_account_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_collectors_member_account_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_collectors_member_account_entries_deleted_at" to table: "collectors_member_account_entries"
CREATE INDEX "idx_collectors_member_account_entries_deleted_at" ON "collectors_member_account_entries" ("deleted_at");
-- create index "idx_organization_branch_collectors_member_account_entry" to table: "collectors_member_account_entries"
CREATE INDEX "idx_organization_branch_collectors_member_account_entry" ON "collectors_member_account_entries" ("organization_id", "branch_id");
-- create "comaker_collaterals" table
CREATE TABLE "comaker_collaterals" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "collateral_id" uuid NOT NULL,
  "amount" numeric NOT NULL,
  "description" text NULL,
  "months_count" bigint NULL DEFAULT 0,
  "year_count" bigint NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_comaker_collaterals_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_comaker_collaterals_collateral" FOREIGN KEY ("collateral_id") REFERENCES "collaterals" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_comaker_collaterals_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_comaker_collaterals_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_comaker_collaterals_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_comaker_collaterals_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_comaker_collaterals" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_comaker_collaterals_deleted_at" to table: "comaker_collaterals"
CREATE INDEX "idx_comaker_collaterals_deleted_at" ON "comaker_collaterals" ("deleted_at");
-- create index "idx_loan_transaction_comaker_collateral" to table: "comaker_collaterals"
CREATE INDEX "idx_loan_transaction_comaker_collateral" ON "comaker_collaterals" ("loan_transaction_id");
-- create index "idx_organization_branch_comaker_collateral" to table: "comaker_collaterals"
CREATE INDEX "idx_organization_branch_comaker_collateral" ON "comaker_collaterals" ("organization_id", "branch_id");
-- create "comaker_member_profiles" table
CREATE TABLE "comaker_member_profiles" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "amount" numeric NOT NULL,
  "description" text NULL,
  "months_count" bigint NULL DEFAULT 0,
  "year_count" bigint NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_comaker_member_profiles_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_comaker_member_profiles_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_comaker_member_profiles_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_comaker_member_profiles_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_comaker_member_profiles_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_comaker_member_profiles_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_comaker_member_profiles" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_comaker_member_profiles_deleted_at" to table: "comaker_member_profiles"
CREATE INDEX "idx_comaker_member_profiles_deleted_at" ON "comaker_member_profiles" ("deleted_at");
-- create index "idx_loan_transaction_comaker" to table: "comaker_member_profiles"
CREATE INDEX "idx_loan_transaction_comaker" ON "comaker_member_profiles" ("loan_transaction_id");
-- create index "idx_organization_branch_comaker_member_profile" to table: "comaker_member_profiles"
CREATE INDEX "idx_organization_branch_comaker_member_profile" ON "comaker_member_profiles" ("organization_id", "branch_id");
-- create "companies" table
CREATE TABLE "companies" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_companies_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_companies_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_companies_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_companies_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_companies_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_companies_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_companies_deleted_at" to table: "companies"
CREATE INDEX "idx_companies_deleted_at" ON "companies" ("deleted_at");
-- create index "idx_organization_branch_company" to table: "companies"
CREATE INDEX "idx_organization_branch_company" ON "companies" ("organization_id", "branch_id");
-- create "disbursements" table
CREATE TABLE "disbursements" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "icon" character varying(50) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_disbursements_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_disbursements_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_disbursements_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_disbursements_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_disbursements_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_disbursements_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_disbursements_deleted_at" to table: "disbursements"
CREATE INDEX "idx_disbursements_deleted_at" ON "disbursements" ("deleted_at");
-- create index "idx_organization_branch_disbursement" to table: "disbursements"
CREATE INDEX "idx_organization_branch_disbursement" ON "disbursements" ("organization_id", "branch_id");
-- create "disbursement_transactions" table
CREATE TABLE "disbursement_transactions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "transaction_batch_id" uuid NOT NULL,
  "employee_user_id" uuid NOT NULL,
  "disbursement_id" uuid NOT NULL,
  "reference_number" character varying(50) NULL,
  "amount" numeric NULL,
  "description" text NULL,
  "employee_name" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_disbursement_transactions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_disbursement_transactions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_disbursement_transactions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_disbursement_transactions_disbursement" FOREIGN KEY ("disbursement_id") REFERENCES "disbursements" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_disbursement_transactions_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_disbursement_transactions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_disbursement_transactions_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_disbursement_transactions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_disbursement_transactions_deleted_at" to table: "disbursement_transactions"
CREATE INDEX "idx_disbursement_transactions_deleted_at" ON "disbursement_transactions" ("deleted_at");
-- create index "idx_organization_branch_disbursement_transaction" to table: "disbursement_transactions"
CREATE INDEX "idx_organization_branch_disbursement_transaction" ON "disbursement_transactions" ("organization_id", "branch_id");
-- create "feeds" table
CREATE TABLE "feeds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NOT NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "description" character varying(255) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_feeds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feeds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_feeds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feeds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feeds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_feeds_deleted_at" to table: "feeds"
CREATE INDEX "idx_feeds_deleted_at" ON "feeds" ("deleted_at");
-- create index "idx_organization_branch_feed" to table: "feeds"
CREATE INDEX "idx_organization_branch_feed" ON "feeds" ("organization_id", "branch_id");
-- create "feed_comments" table
CREATE TABLE "feed_comments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "feed_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "comment" text NOT NULL,
  "media_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_feed_comments_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_comments_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_comments_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_comments_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_comments_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_comments_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_comments_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_feeds_feed_comments" FOREIGN KEY ("feed_id") REFERENCES "feeds" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_feed_comment" to table: "feed_comments"
CREATE INDEX "idx_feed_comment" ON "feed_comments" ("feed_id", "user_id");
-- create index "idx_feed_comments_deleted_at" to table: "feed_comments"
CREATE INDEX "idx_feed_comments_deleted_at" ON "feed_comments" ("deleted_at");
-- create index "idx_organization_branch_feed_comment" to table: "feed_comments"
CREATE INDEX "idx_organization_branch_feed_comment" ON "feed_comments" ("organization_id", "branch_id");
-- create "feed_likes" table
CREATE TABLE "feed_likes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "feed_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_feed_likes_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_likes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_likes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_likes_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_likes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_likes_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_feeds_user_likes" FOREIGN KEY ("feed_id") REFERENCES "feeds" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_feed_like_unique" to table: "feed_likes"
CREATE UNIQUE INDEX "idx_feed_like_unique" ON "feed_likes" ("feed_id", "user_id");
-- create index "idx_feed_likes_deleted_at" to table: "feed_likes"
CREATE INDEX "idx_feed_likes_deleted_at" ON "feed_likes" ("deleted_at");
-- create index "idx_organization_branch_feed_like" to table: "feed_likes"
CREATE INDEX "idx_organization_branch_feed_like" ON "feed_likes" ("organization_id", "branch_id");
-- create "feed_media" table
CREATE TABLE "feed_media" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "feed_id" uuid NOT NULL,
  "media_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_feed_media_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_media_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_media_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feed_media_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_feed_media_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_feed_media_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_feeds_feed_medias" FOREIGN KEY ("feed_id") REFERENCES "feeds" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_feed_media" to table: "feed_media"
CREATE INDEX "idx_feed_media" ON "feed_media" ("feed_id", "media_id");
-- create index "idx_feed_media_deleted_at" to table: "feed_media"
CREATE INDEX "idx_feed_media_deleted_at" ON "feed_media" ("deleted_at");
-- create index "idx_organization_branch_feed_media" to table: "feed_media"
CREATE INDEX "idx_organization_branch_feed_media" ON "feed_media" ("organization_id", "branch_id");
-- create "feedbacks" table
CREATE TABLE "feedbacks" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "email" character varying(255) NULL,
  "description" text NULL,
  "feedback_type" character varying(50) NOT NULL DEFAULT 'general',
  "media_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_feedbacks_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_feedbacks_deleted_at" to table: "feedbacks"
CREATE INDEX "idx_feedbacks_deleted_at" ON "feedbacks" ("deleted_at");
-- create "fines_maturities" table
CREATE TABLE "fines_maturities" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "from" bigint NOT NULL DEFAULT 0,
  "to" bigint NOT NULL DEFAULT 0,
  "rate" numeric NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_fines_maturities_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_fines_maturities_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_fines_maturities_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_fines_maturities_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_fines_maturities_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_fines_maturities_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_fines_maturities_deleted_at" to table: "fines_maturities"
CREATE INDEX "idx_fines_maturities_deleted_at" ON "fines_maturities" ("deleted_at");
-- create index "idx_organization_branch_fines_maturity" to table: "fines_maturities"
CREATE INDEX "idx_organization_branch_fines_maturity" ON "fines_maturities" ("organization_id", "branch_id");
-- create "footsteps" table
CREATE TABLE "footsteps" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NULL,
  "branch_id" uuid NULL,
  "user_id" uuid NULL,
  "media_id" uuid NULL,
  "description" text NOT NULL,
  "activity" text NOT NULL,
  "user_type" character varying(11) NULL,
  "module" character varying(255) NULL,
  "latitude" numeric(10,7) NULL,
  "longitude" numeric(10,7) NULL,
  "timestamp" timestamp NULL,
  "is_deleted" boolean NULL DEFAULT false,
  "ip_address" character varying(45) NULL,
  "user_agent" character varying(1000) NULL,
  "referer" character varying(1000) NULL,
  "location" character varying(255) NULL,
  "accept_language" character varying(255) NULL,
  "level" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branches_footsteps" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_footsteps_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_footsteps_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_footsteps_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_footsteps_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_footsteps" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_users_footsteps" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_branch_org_footstep" to table: "footsteps"
CREATE INDEX "idx_branch_org_footstep" ON "footsteps" ("organization_id", "branch_id");
-- create index "idx_footsteps_deleted_at" to table: "footsteps"
CREATE INDEX "idx_footsteps_deleted_at" ON "footsteps" ("deleted_at");
-- create "funds" table
CREATE TABLE "funds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "type" character varying(255) NULL,
  "description" text NULL,
  "icon" character varying(255) NULL,
  "gl_books" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_funds_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_funds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_funds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_funds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_funds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_funds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_funds_deleted_at" to table: "funds"
CREATE INDEX "idx_funds_deleted_at" ON "funds" ("deleted_at");
-- create index "idx_organization_branch_funds" to table: "funds"
CREATE INDEX "idx_organization_branch_funds" ON "funds" ("organization_id", "branch_id");
-- create "general_account_grouping_net_surplus_negatives" table
CREATE TABLE "general_account_grouping_net_surplus_negatives" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "percentage1" numeric NULL DEFAULT 0,
  "percentage2" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_negatives_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_general_account_grouping_net_surplus_negatives_deleted_at" to table: "general_account_grouping_net_surplus_negatives"
CREATE INDEX "idx_general_account_grouping_net_surplus_negatives_deleted_at" ON "general_account_grouping_net_surplus_negatives" ("deleted_at");
-- create index "idx_organization_branch_general_account_grouping_net_surplus_ne" to table: "general_account_grouping_net_surplus_negatives"
CREATE INDEX "idx_organization_branch_general_account_grouping_net_surplus_ne" ON "general_account_grouping_net_surplus_negatives" ("organization_id", "branch_id");
-- create "general_account_grouping_net_surplus_positives" table
CREATE TABLE "general_account_grouping_net_surplus_positives" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "percentage1" numeric NULL DEFAULT 0,
  "percentage2" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_account_grouping_net_surplus_positives_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_general_account_grouping_net_surplus_positives_deleted_at" to table: "general_account_grouping_net_surplus_positives"
CREATE INDEX "idx_general_account_grouping_net_surplus_positives_deleted_at" ON "general_account_grouping_net_surplus_positives" ("deleted_at");
-- create index "idx_organization_branch_general_account_grouping_net_surplus_po" to table: "general_account_grouping_net_surplus_positives"
CREATE INDEX "idx_organization_branch_general_account_grouping_net_surplus_po" ON "general_account_grouping_net_surplus_positives" ("organization_id", "branch_id");
-- create "member_joint_accounts" table
CREATE TABLE "member_joint_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "picture_media_id" uuid NOT NULL,
  "signature_media_id" uuid NOT NULL,
  "description" text NULL,
  "first_name" character varying(255) NOT NULL,
  "middle_name" character varying(255) NULL,
  "last_name" character varying(255) NOT NULL,
  "full_name" character varying(255) NOT NULL,
  "suffix" character varying(255) NULL,
  "birthday" timestamptz NOT NULL,
  "family_relationship" character varying(255) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_joint_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_joint_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_joint_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_joint_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_joint_accounts_picture_media" FOREIGN KEY ("picture_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_joint_accounts_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_joint_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_joint_accounts" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_joint_accounts_deleted_at" to table: "member_joint_accounts"
CREATE INDEX "idx_member_joint_accounts_deleted_at" ON "member_joint_accounts" ("deleted_at");
-- create index "idx_organization_branch_member_join_account" to table: "member_joint_accounts"
CREATE INDEX "idx_organization_branch_member_join_account" ON "member_joint_accounts" ("organization_id", "branch_id");
-- create "transactions" table
CREATE TABLE "transactions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "signature_media_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "revolving_fund_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "member_joint_account_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "loan_balance" numeric NULL DEFAULT 0,
  "loan_due" numeric NULL DEFAULT 0,
  "total_due" numeric NULL DEFAULT 0,
  "fines_due" numeric NULL DEFAULT 0,
  "total_loan" numeric NULL DEFAULT 0,
  "interest_due" numeric NULL DEFAULT 0,
  "reference_number" character varying(50) NULL,
  "amount" numeric NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_transactions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transactions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transactions_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transactions_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_member_joint_account" FOREIGN KEY ("member_joint_account_id") REFERENCES "member_joint_accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transactions_revolving_fund" FOREIGN KEY ("revolving_fund_id") REFERENCES "revolving_funds" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_transactions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_transaction" to table: "transactions"
CREATE INDEX "idx_organization_branch_transaction" ON "transactions" ("organization_id", "branch_id");
-- create index "idx_transactions_deleted_at" to table: "transactions"
CREATE INDEX "idx_transactions_deleted_at" ON "transactions" ("deleted_at");
-- create "general_ledgers" table
CREATE TABLE "general_ledgers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "transaction_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "member_joint_account_id" uuid NULL,
  "transaction_reference_number" character varying(50) NULL,
  "reference_number" character varying(50) NULL,
  "payment_type_id" uuid NULL,
  "source" character varying(20) NULL,
  "journal_voucher_id" uuid NULL,
  "adjustment_entry_id" uuid NULL,
  "loan_transaction_id" uuid NULL,
  "type_of_payment_type" character varying(20) NULL,
  "credit" numeric NULL,
  "debit" numeric NULL,
  "balance" numeric NULL,
  "signature_media_id" uuid NULL,
  "entry_date" timestamp NOT NULL DEFAULT now(),
  "bank_id" uuid NULL,
  "proof_of_payment_media_id" uuid NULL,
  "currency_id" uuid NULL,
  "bank_reference_number" character varying(50) NULL,
  "description" text NULL,
  "print_number" bigint NULL DEFAULT 0,
  "revolving_fund_id" uuid NULL,
  "particular" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_general_ledgers_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_adjustment_entry" FOREIGN KEY ("adjustment_entry_id") REFERENCES "adjustment_entries" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_ledgers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_ledgers_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_ledgers_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_member_joint_account" FOREIGN KEY ("member_joint_account_id") REFERENCES "member_joint_accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_ledgers_payment_type" FOREIGN KEY ("payment_type_id") REFERENCES "payment_types" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_proof_of_payment_media" FOREIGN KEY ("proof_of_payment_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_revolving_fund" FOREIGN KEY ("revolving_fund_id") REFERENCES "revolving_funds" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_signature_media" FOREIGN KEY ("signature_media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_general_ledgers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transactions_general_ledgers" FOREIGN KEY ("transaction_id") REFERENCES "transactions" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_general_ledgers_created_at" to table: "general_ledgers"
CREATE INDEX "idx_general_ledgers_created_at" ON "general_ledgers" ("created_at");
-- create index "idx_general_ledgers_deleted_at" to table: "general_ledgers"
CREATE INDEX "idx_general_ledgers_deleted_at" ON "general_ledgers" ("deleted_at");
-- create index "idx_ledger_pagination" to table: "general_ledgers"
CREATE INDEX "idx_ledger_pagination" ON "general_ledgers" ("entry_date");
-- create index "idx_org_branch_account_member" to table: "general_ledgers"
CREATE INDEX "idx_org_branch_account_member" ON "general_ledgers" ("organization_id", "branch_id", "account_id", "member_profile_id");
-- create index "idx_organization_branch_general_ledger" to table: "general_ledgers"
CREATE INDEX "idx_organization_branch_general_ledger" ON "general_ledgers" ("organization_id", "branch_id");
-- create index "idx_transaction_batch_entry" to table: "general_ledgers"
CREATE INDEX "idx_transaction_batch_entry" ON "general_ledgers" ("organization_id", "branch_id", "transaction_batch_id");
-- create "general_accounting_ledger_tags" table
CREATE TABLE "general_accounting_ledger_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "general_ledger_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_general_accounting_ledger_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_accounting_ledger_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_accounting_ledger_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_general_accounting_ledger_tags_general_ledger" FOREIGN KEY ("general_ledger_id") REFERENCES "general_ledgers" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_accounting_ledger_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_general_accounting_ledger_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_general_accounting_ledger_tags_deleted_at" to table: "general_accounting_ledger_tags"
CREATE INDEX "idx_general_accounting_ledger_tags_deleted_at" ON "general_accounting_ledger_tags" ("deleted_at");
-- create index "idx_organization_branch_general_ledger_tag" to table: "general_accounting_ledger_tags"
CREATE INDEX "idx_organization_branch_general_ledger_tag" ON "general_accounting_ledger_tags" ("organization_id", "branch_id");
-- create "generated_reports" table
CREATE TABLE "generated_reports" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "user_id" uuid NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "status" character varying(50) NOT NULL,
  "system_message" text NULL,
  "is_favorite" boolean NULL DEFAULT false,
  "module" character varying(255) NULL,
  "template" text NULL DEFAULT '',
  "width" character varying(50) NULL,
  "height" character varying(50) NULL,
  "orientation" character varying(50) NULL DEFAULT 'portrait',
  "landscape" boolean NULL DEFAULT false,
  "filters" jsonb NULL DEFAULT '{}',
  "has_password" boolean NULL DEFAULT false,
  "expiration_days" bigint NULL DEFAULT 7,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branches_generated_reports" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_generated_reports_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_reports_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_reports_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_generated_reports_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_generated_reports" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_users_generated_reports" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_branch_org_generated_report" to table: "generated_reports"
CREATE INDEX "idx_branch_org_generated_report" ON "generated_reports" ("organization_id", "branch_id");
-- create index "idx_generated_reports_deleted_at" to table: "generated_reports"
CREATE INDEX "idx_generated_reports_deleted_at" ON "generated_reports" ("deleted_at");
-- create "user_organizations" table
CREATE TABLE "user_organizations" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NULL,
  "user_id" uuid NOT NULL,
  "user_type" character varying(50) NOT NULL,
  "description" text NULL,
  "application_description" text NULL,
  "application_status" character varying(50) NOT NULL DEFAULT 'pending',
  "developer_secret_key" character varying(255) NOT NULL,
  "permission_name" character varying(255) NOT NULL,
  "permission_description" character varying(255) NOT NULL,
  "permissions" character varying(255)[] NULL,
  "is_seeded" boolean NOT NULL DEFAULT false,
  "user_setting_description" text NULL,
  "payment_or_unique" boolean NOT NULL DEFAULT false,
  "payment_or_allow_user_input" boolean NOT NULL DEFAULT true,
  "payment_or_current" bigint NOT NULL DEFAULT 1,
  "payment_or_end" bigint NOT NULL DEFAULT 9999,
  "payment_or_start" bigint NOT NULL DEFAULT 1,
  "payment_or_iteration" bigint NOT NULL DEFAULT 1,
  "payment_or_use_date_or" boolean NOT NULL DEFAULT false,
  "payment_prefix" character varying(50) NULL DEFAULT '',
  "payment_padding" bigint NOT NULL DEFAULT 6,
  "settings_allow_withdraw_negative_balance" boolean NOT NULL DEFAULT false,
  "settings_maintaining_balance" boolean NOT NULL DEFAULT false,
  "status" character varying(50) NOT NULL DEFAULT 'offline',
  "last_online_at" timestamptz NULL DEFAULT now(),
  "time_machine_time" timestamp NULL,
  "settings_accounting_payment_default_value_id" uuid NULL,
  "settings_accounting_deposit_default_value_id" uuid NULL,
  "settings_accounting_withdraw_default_value_id" uuid NULL,
  "settings_payment_type_default_value_id" uuid NULL,
  "loan_voucher_auto_increment" boolean NOT NULL DEFAULT false,
  "adjustment_entry_auto_increment" boolean NOT NULL DEFAULT false,
  "journal_voucher_auto_increment" boolean NOT NULL DEFAULT false,
  "cash_check_voucher_auto_increment" boolean NOT NULL DEFAULT false,
  "deposit_auto_increment" boolean NOT NULL DEFAULT false,
  "withdraw_auto_increment" boolean NOT NULL DEFAULT false,
  "payment_auto_increment" boolean NOT NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_user_organizations_developer_secret_key" UNIQUE ("developer_secret_key"),
  CONSTRAINT "fk_branches_user_organizations" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_organizations_user_organizations" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_user_organizations_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_settings_accounting_deposit_default_value" FOREIGN KEY ("settings_accounting_deposit_default_value_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_settings_accounting_payment_default_value" FOREIGN KEY ("settings_accounting_payment_default_value_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_settings_accounting_withdraw_default_valu" FOREIGN KEY ("settings_accounting_withdraw_default_value_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_settings_payment_type_default_value" FOREIGN KEY ("settings_payment_type_default_value_id") REFERENCES "payment_types" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_organizations_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_users_user_organizations" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_user_org_branch" to table: "user_organizations"
CREATE INDEX "idx_user_org_branch" ON "user_organizations" ("organization_id", "branch_id", "user_id");
-- create index "idx_user_organizations_deleted_at" to table: "user_organizations"
CREATE INDEX "idx_user_organizations_deleted_at" ON "user_organizations" ("deleted_at");
-- create index "idx_user_organizations_settings_accounting_deposit_defae220a44c" to table: "user_organizations"
CREATE INDEX "idx_user_organizations_settings_accounting_deposit_defae220a44c" ON "user_organizations" ("settings_accounting_deposit_default_value_id");
-- create index "idx_user_organizations_settings_accounting_payment_defacde68a25" to table: "user_organizations"
CREATE INDEX "idx_user_organizations_settings_accounting_payment_defacde68a25" ON "user_organizations" ("settings_accounting_payment_default_value_id");
-- create index "idx_user_organizations_settings_accounting_withdraw_def5e5c1fbd" to table: "user_organizations"
CREATE INDEX "idx_user_organizations_settings_accounting_withdraw_def5e5c1fbd" ON "user_organizations" ("settings_accounting_withdraw_default_value_id");
-- create index "idx_user_organizations_settings_payment_type_default_value_id" to table: "user_organizations"
CREATE INDEX "idx_user_organizations_settings_payment_type_default_value_id" ON "user_organizations" ("settings_payment_type_default_value_id");
-- create "generated_reports_download_users" table
CREATE TABLE "generated_reports_download_users" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "user_organization_id" uuid NOT NULL,
  "generated_report_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_generated_reports_download_users" FOREIGN KEY ("generated_report_id") REFERENCES "generated_reports" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_generated_reports_download_users_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_reports_download_users_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_reports_download_users_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_reports_download_users_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_reports_download_users_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_reports_download_users_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_reports_download_users_user_organization" FOREIGN KEY ("user_organization_id") REFERENCES "user_organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_generated_report_download_users" to table: "generated_reports_download_users"
CREATE INDEX "idx_generated_report_download_users" ON "generated_reports_download_users" ("generated_report_id");
-- create index "idx_generated_reports_download_users_deleted_at" to table: "generated_reports_download_users"
CREATE INDEX "idx_generated_reports_download_users_deleted_at" ON "generated_reports_download_users" ("deleted_at");
-- create index "idx_organization_branch_generated_reports_download_users" to table: "generated_reports_download_users"
CREATE INDEX "idx_organization_branch_generated_reports_download_users" ON "generated_reports_download_users" ("organization_id", "branch_id");
-- create index "idx_user_generated_reports_download" to table: "generated_reports_download_users"
CREATE INDEX "idx_user_generated_reports_download" ON "generated_reports_download_users" ("user_id");
-- create index "idx_user_organization_generated_reports_download" to table: "generated_reports_download_users"
CREATE INDEX "idx_user_organization_generated_reports_download" ON "generated_reports_download_users" ("user_organization_id");
-- create "generated_savings_interests" table
CREATE TABLE "generated_savings_interests" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "document_no" character varying(255) NULL DEFAULT '',
  "last_computation_date" timestamptz NOT NULL,
  "new_computation_date" timestamptz NOT NULL,
  "account_id" uuid NULL,
  "member_type_id" uuid NULL,
  "savings_computation_type" character varying(50) NOT NULL,
  "include_closed_account" boolean NULL DEFAULT false,
  "include_existing_computed_interest" boolean NULL DEFAULT false,
  "interest_tax_rate" numeric(15,6) NULL DEFAULT 0,
  "total_interest" numeric(15,2) NULL DEFAULT 0,
  "total_tax" numeric(15,2) NULL DEFAULT 0,
  "printed_by_user_id" uuid NULL,
  "printed_date" timestamptz NULL,
  "posted_by_user_id" uuid NULL,
  "posted_date" timestamptz NULL,
  "check_voucher_number" character varying(255) NULL,
  "post_account_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_generated_savings_interests_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_savings_interests_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_savings_interests_post_account" FOREIGN KEY ("post_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_generated_savings_interests_posted_by_user" FOREIGN KEY ("posted_by_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_printed_by_user" FOREIGN KEY ("printed_by_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_generated_savings_interests_deleted_at" to table: "generated_savings_interests"
CREATE INDEX "idx_generated_savings_interests_deleted_at" ON "generated_savings_interests" ("deleted_at");
-- create index "idx_organization_branch_generated_savings_interest" to table: "generated_savings_interests"
CREATE INDEX "idx_organization_branch_generated_savings_interest" ON "generated_savings_interests" ("organization_id", "branch_id");
-- create "generated_savings_interest_entries" table
CREATE TABLE "generated_savings_interest_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "generated_savings_interest_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "ending_balance" numeric(15,2) NOT NULL,
  "interest_amount" numeric(15,2) NOT NULL,
  "interest_tax" numeric(15,2) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_generated_savings_interest_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_generated_savings_interest_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_savings_interest_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interest_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interest_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_generated_savings_interest_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_generated_savings_interest_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_generated_savings_interests_entries" FOREIGN KEY ("generated_savings_interest_id") REFERENCES "generated_savings_interests" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_account_member_profile_entry" to table: "generated_savings_interest_entries"
CREATE INDEX "idx_account_member_profile_entry" ON "generated_savings_interest_entries" ("account_id", "member_profile_id");
-- create index "idx_generated_savings_interest_entries_deleted_at" to table: "generated_savings_interest_entries"
CREATE INDEX "idx_generated_savings_interest_entries_deleted_at" ON "generated_savings_interest_entries" ("deleted_at");
-- create index "idx_generated_savings_interest_entry" to table: "generated_savings_interest_entries"
CREATE INDEX "idx_generated_savings_interest_entry" ON "generated_savings_interest_entries" ("generated_savings_interest_id");
-- create index "idx_organization_branch_generate_savings_interest_entry" to table: "generated_savings_interest_entries"
CREATE INDEX "idx_organization_branch_generate_savings_interest_entry" ON "generated_savings_interest_entries" ("organization_id", "branch_id");
-- create "grocery_computation_sheets" table
CREATE TABLE "grocery_computation_sheets" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "scheme_number" bigint NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_grocery_computation_sheets_scheme_number" UNIQUE ("scheme_number"),
  CONSTRAINT "fk_grocery_computation_sheets_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_grocery_computation_sheets_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_grocery_computation_sheets_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_grocery_computation_sheets_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_grocery_computation_sheets_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_grocery_computation_sheets_deleted_at" to table: "grocery_computation_sheets"
CREATE INDEX "idx_grocery_computation_sheets_deleted_at" ON "grocery_computation_sheets" ("deleted_at");
-- create index "idx_organization_branch_grocery_computation_sheet" to table: "grocery_computation_sheets"
CREATE INDEX "idx_organization_branch_grocery_computation_sheet" ON "grocery_computation_sheets" ("organization_id", "branch_id");
-- create "grocery_computation_sheet_monthlies" table
CREATE TABLE "grocery_computation_sheet_monthlies" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "grocery_computation_sheet_id" uuid NOT NULL,
  "months" bigint NULL DEFAULT 0,
  "interest_rate" numeric NULL DEFAULT 0,
  "loan_guaranteed_fund_rate" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_grocery_computation_shee" FOREIGN KEY ("grocery_computation_sheet_id") REFERENCES "grocery_computation_sheets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_grocery_computation_sheet_monthlies_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_grocery_computation_sheet_monthlies_deleted_at" to table: "grocery_computation_sheet_monthlies"
CREATE INDEX "idx_grocery_computation_sheet_monthlies_deleted_at" ON "grocery_computation_sheet_monthlies" ("deleted_at");
-- create index "idx_organization_branch_grocery_computation_sheet_monthly" to table: "grocery_computation_sheet_monthlies"
CREATE INDEX "idx_organization_branch_grocery_computation_sheet_monthly" ON "grocery_computation_sheet_monthlies" ("organization_id", "branch_id");
-- create "holidays" table
CREATE TABLE "holidays" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "entry_date" timestamptz NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_holidays_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_holidays_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_holidays_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_holidays_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_holidays_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_holidays_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_holidays_deleted_at" to table: "holidays"
CREATE INDEX "idx_holidays_deleted_at" ON "holidays" ("deleted_at");
-- create index "idx_organization_branch_holidays" to table: "holidays"
CREATE INDEX "idx_organization_branch_holidays" ON "holidays" ("organization_id", "branch_id");
-- create "include_negative_accounts" table
CREATE TABLE "include_negative_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "computation_sheet_id" uuid NULL,
  "account_id" uuid NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_include_negative_accounts_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_include_negative_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_include_negative_accounts_computation_sheet" FOREIGN KEY ("computation_sheet_id") REFERENCES "computation_sheets" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_include_negative_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_include_negative_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_include_negative_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_include_negative_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_include_negative_accounts_deleted_at" to table: "include_negative_accounts"
CREATE INDEX "idx_include_negative_accounts_deleted_at" ON "include_negative_accounts" ("deleted_at");
-- create index "idx_organization_branch_include_negative_account" to table: "include_negative_accounts"
CREATE INDEX "idx_organization_branch_include_negative_account" ON "include_negative_accounts" ("organization_id", "branch_id");
-- create "interest_maturities" table
CREATE TABLE "interest_maturities" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "from" bigint NOT NULL DEFAULT 0,
  "to" bigint NOT NULL DEFAULT 0,
  "rate" numeric NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_interest_maturities_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_maturities_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_maturities_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_maturities_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_maturities_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_maturities_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_interest_maturities_deleted_at" to table: "interest_maturities"
CREATE INDEX "idx_interest_maturities_deleted_at" ON "interest_maturities" ("deleted_at");
-- create index "idx_organization_branch_interest_maturity" to table: "interest_maturities"
CREATE INDEX "idx_organization_branch_interest_maturity" ON "interest_maturities" ("organization_id", "branch_id");
-- create "interest_rate_by_amounts" table
CREATE TABLE "interest_rate_by_amounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "browse_reference_id" uuid NOT NULL,
  "from_amount" numeric(15,2) NOT NULL,
  "to_amount" numeric(15,2) NOT NULL,
  "interest_rate" numeric(15,6) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_browse_references_interest_rates_by_amount" FOREIGN KEY ("browse_reference_id") REFERENCES "browse_references" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_amounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_amounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_amounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_amounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_amounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_browse_reference_amount_range" to table: "interest_rate_by_amounts"
CREATE INDEX "idx_browse_reference_amount_range" ON "interest_rate_by_amounts" ("browse_reference_id", "from_amount", "to_amount");
-- create index "idx_interest_rate_by_amounts_deleted_at" to table: "interest_rate_by_amounts"
CREATE INDEX "idx_interest_rate_by_amounts_deleted_at" ON "interest_rate_by_amounts" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_by_amount" to table: "interest_rate_by_amounts"
CREATE INDEX "idx_organization_branch_interest_rate_by_amount" ON "interest_rate_by_amounts" ("organization_id", "branch_id");
-- create "interest_rate_by_dates" table
CREATE TABLE "interest_rate_by_dates" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "browse_reference_id" uuid NOT NULL,
  "from_date" timestamptz NOT NULL,
  "to_date" timestamptz NOT NULL,
  "interest_rate" numeric(15,6) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_browse_references_interest_rates_by_date" FOREIGN KEY ("browse_reference_id") REFERENCES "browse_references" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_dates_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_dates_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_dates_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_dates_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_dates_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_browse_reference_date_range" to table: "interest_rate_by_dates"
CREATE INDEX "idx_browse_reference_date_range" ON "interest_rate_by_dates" ("browse_reference_id", "from_date", "to_date");
-- create index "idx_interest_rate_by_dates_deleted_at" to table: "interest_rate_by_dates"
CREATE INDEX "idx_interest_rate_by_dates_deleted_at" ON "interest_rate_by_dates" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_by_date" to table: "interest_rate_by_dates"
CREATE INDEX "idx_organization_branch_interest_rate_by_date" ON "interest_rate_by_dates" ("organization_id", "branch_id");
-- create "interest_rate_schemes" table
CREATE TABLE "interest_rate_schemes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_interest_rate_schemes_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_schemes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_schemes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_schemes_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_schemes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_interest_rate_schemes_deleted_at" to table: "interest_rate_schemes"
CREATE INDEX "idx_interest_rate_schemes_deleted_at" ON "interest_rate_schemes" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_scheme" to table: "interest_rate_schemes"
CREATE INDEX "idx_organization_branch_interest_rate_scheme" ON "interest_rate_schemes" ("organization_id", "branch_id");
-- create "member_classification_interest_rates" table
CREATE TABLE "member_classification_interest_rates" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "interest_rate_scheme_id" uuid NULL,
  "member_classification_id" uuid NULL,
  "header1" bigint NULL DEFAULT 30,
  "header2" bigint NULL DEFAULT 60,
  "header3" bigint NULL DEFAULT 90,
  "header4" bigint NULL DEFAULT 120,
  "header5" bigint NULL DEFAULT 150,
  "header6" bigint NULL DEFAULT 180,
  "header7" bigint NULL DEFAULT 210,
  "header8" bigint NULL DEFAULT 240,
  "header9" bigint NULL DEFAULT 270,
  "header10" bigint NULL DEFAULT 300,
  "header11" bigint NULL DEFAULT 330,
  "header12" bigint NULL DEFAULT 360,
  "header13" bigint NULL DEFAULT 390,
  "header14" bigint NULL DEFAULT 410,
  "header15" bigint NULL DEFAULT 440,
  "header16" bigint NULL DEFAULT 470,
  "header17" bigint NULL DEFAULT 500,
  "header18" bigint NULL DEFAULT 530,
  "header19" bigint NULL DEFAULT 560,
  "header20" bigint NULL DEFAULT 590,
  "header21" bigint NULL DEFAULT 610,
  "header22" bigint NULL DEFAULT 640,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_classification_interest_rates_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classification_interest_rates_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classification_interest_rates_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classification_interest_rates_interest_rate_scheme" FOREIGN KEY ("interest_rate_scheme_id") REFERENCES "interest_rate_schemes" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_classification_interest_rates_member_classification" FOREIGN KEY ("member_classification_id") REFERENCES "member_classifications" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_classification_interest_rates_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classification_interest_rates_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_classification_interest_rates_deleted_at" to table: "member_classification_interest_rates"
CREATE INDEX "idx_member_classification_interest_rates_deleted_at" ON "member_classification_interest_rates" ("deleted_at");
-- create index "idx_organization_branch_member_classification_interest_rate" to table: "member_classification_interest_rates"
CREATE INDEX "idx_organization_branch_member_classification_interest_rate" ON "member_classification_interest_rates" ("organization_id", "branch_id");
-- create "interest_rate_by_terms" table
CREATE TABLE "interest_rate_by_terms" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "descrition" text NULL,
  "member_classification_interest_rate_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_interest_rate_by_terms_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_terms_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_terms_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_terms_member_classification_interest_rate" FOREIGN KEY ("member_classification_interest_rate_id") REFERENCES "member_classification_interest_rates" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_terms_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_terms_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_interest_rate_by_terms_deleted_at" to table: "interest_rate_by_terms"
CREATE INDEX "idx_interest_rate_by_terms_deleted_at" ON "interest_rate_by_terms" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_by_term" to table: "interest_rate_by_terms"
CREATE INDEX "idx_organization_branch_interest_rate_by_term" ON "interest_rate_by_terms" ("organization_id", "branch_id");
-- create "interest_rate_by_years" table
CREATE TABLE "interest_rate_by_years" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "browse_reference_id" uuid NOT NULL,
  "from_year" bigint NOT NULL,
  "to_year" bigint NOT NULL,
  "interest_rate" numeric(15,6) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_browse_references_interest_rates_by_year" FOREIGN KEY ("browse_reference_id") REFERENCES "browse_references" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_years_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_years_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_years_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_by_years_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_by_years_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_browse_reference_year_range" to table: "interest_rate_by_years"
CREATE INDEX "idx_browse_reference_year_range" ON "interest_rate_by_years" ("browse_reference_id", "from_year", "to_year");
-- create index "idx_interest_rate_by_years_deleted_at" to table: "interest_rate_by_years"
CREATE INDEX "idx_interest_rate_by_years_deleted_at" ON "interest_rate_by_years" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_by_year" to table: "interest_rate_by_years"
CREATE INDEX "idx_organization_branch_interest_rate_by_year" ON "interest_rate_by_years" ("organization_id", "branch_id");
-- create "interest_rate_percentages" table
CREATE TABLE "interest_rate_percentages" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" character varying(4028) NULL,
  "months" bigint NULL DEFAULT 0,
  "interest_rate" numeric NULL DEFAULT 0,
  "member_classification_interest_rate_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_interest_rate_percentages_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_percentages_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_percentages_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_percentages_member_classification_interest_rat" FOREIGN KEY ("member_classification_interest_rate_id") REFERENCES "member_classification_interest_rates" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_interest_rate_percentages_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_interest_rate_percentages_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_interest_rate_percentages_deleted_at" to table: "interest_rate_percentages"
CREATE INDEX "idx_interest_rate_percentages_deleted_at" ON "interest_rate_percentages" ("deleted_at");
-- create index "idx_organization_branch_interest_rate_percentage" to table: "interest_rate_percentages"
CREATE INDEX "idx_organization_branch_interest_rate_percentage" ON "interest_rate_percentages" ("organization_id", "branch_id");
-- create "inventory_brands" table
CREATE TABLE "inventory_brands" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "icon" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_brands_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_brands_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_brands_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_brands_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_brands_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_brands_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_brands_deleted_at" to table: "inventory_brands"
CREATE INDEX "idx_inventory_brands_deleted_at" ON "inventory_brands" ("deleted_at");
-- create index "idx_organization_branch_brand" to table: "inventory_brands"
CREATE INDEX "idx_organization_branch_brand" ON "inventory_brands" ("organization_id", "branch_id");
-- create "inventory_categories" table
CREATE TABLE "inventory_categories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "icon" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_categories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_categories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_categories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_categories_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_categories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_categories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_categories_deleted_at" to table: "inventory_categories"
CREATE INDEX "idx_inventory_categories_deleted_at" ON "inventory_categories" ("deleted_at");
-- create index "idx_organization_branch_category" to table: "inventory_categories"
CREATE INDEX "idx_organization_branch_category" ON "inventory_categories" ("organization_id", "branch_id");
-- create "inventory_hazards" table
CREATE TABLE "inventory_hazards" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "icon" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_hazards_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_hazards_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_hazards_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_hazards_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_hazards_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_hazards_deleted_at" to table: "inventory_hazards"
CREATE INDEX "idx_inventory_hazards_deleted_at" ON "inventory_hazards" ("deleted_at");
-- create index "idx_organization_branch_hazard" to table: "inventory_hazards"
CREATE INDEX "idx_organization_branch_hazard" ON "inventory_hazards" ("organization_id", "branch_id");
-- create "inventory_suppliers" table
CREATE TABLE "inventory_suppliers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "address" text NULL,
  "contact_number" character varying(50) NULL,
  "longitude" numeric(11,8) NULL,
  "latitude" numeric(10,8) NULL,
  "icon" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_suppliers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_suppliers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_suppliers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_suppliers_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_suppliers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_suppliers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_suppliers_deleted_at" to table: "inventory_suppliers"
CREATE INDEX "idx_inventory_suppliers_deleted_at" ON "inventory_suppliers" ("deleted_at");
-- create index "idx_organization_branch_supplier" to table: "inventory_suppliers"
CREATE INDEX "idx_organization_branch_supplier" ON "inventory_suppliers" ("organization_id", "branch_id");
-- create "inventory_warehouses" table
CREATE TABLE "inventory_warehouses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "type" character varying(50) NULL DEFAULT 'Private',
  "code" character varying(50) NOT NULL,
  "address" text NULL,
  "location" character varying(255) NULL,
  "longitude" numeric(11,8) NULL,
  "latitude" numeric(10,8) NULL,
  "icon" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_warehouses_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_warehouses_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_warehouses_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_warehouses_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_warehouses_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_warehouses_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_warehouses_deleted_at" to table: "inventory_warehouses"
CREATE INDEX "idx_inventory_warehouses_deleted_at" ON "inventory_warehouses" ("deleted_at");
-- create index "idx_organization_branch_warehouse" to table: "inventory_warehouses"
CREATE INDEX "idx_organization_branch_warehouse" ON "inventory_warehouses" ("organization_id", "branch_id");
-- create "inventory_items" table
CREATE TABLE "inventory_items" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "category_id" uuid NULL,
  "brand_id" uuid NULL,
  "warehouse_id" uuid NULL,
  "supplier_id" uuid NULL,
  "hazard_id" uuid NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "serial_number" character varying(100) NULL,
  "unit" character varying(50) NULL,
  "total_quantity" numeric(15,2) NULL DEFAULT 0,
  "total_price" numeric(15,2) NULL DEFAULT 0,
  "barcode39" character varying(100) NULL,
  "barcode_ean8" character varying(8) NULL,
  "barcode_ean13" character varying(13) NULL,
  "barcode_upc_a" character varying(12) NULL,
  "barcode_upc_e" character varying(6) NULL,
  "barcode_code128" character varying(100) NULL,
  "barcode_itf14" character varying(14) NULL,
  "barcode_qr_code" text NULL,
  "barcode_pdf417" text NULL,
  "barcode_aztec" text NULL,
  "barcode_data_matrix" text NULL,
  "barcode_gs1_data_bar_expanded" text NULL,
  "barcode_gs1_data_matrix" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_items_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_items_brand" FOREIGN KEY ("brand_id") REFERENCES "inventory_brands" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_category" FOREIGN KEY ("category_id") REFERENCES "inventory_categories" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_hazard" FOREIGN KEY ("hazard_id") REFERENCES "inventory_hazards" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_items_supplier" FOREIGN KEY ("supplier_id") REFERENCES "inventory_suppliers" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_items_warehouse" FOREIGN KEY ("warehouse_id") REFERENCES "inventory_warehouses" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_items_deleted_at" to table: "inventory_items"
CREATE INDEX "idx_inventory_items_deleted_at" ON "inventory_items" ("deleted_at");
-- create index "idx_org_branch_item" to table: "inventory_items"
CREATE INDEX "idx_org_branch_item" ON "inventory_items" ("organization_id", "branch_id");
-- create "inventory_item_entries" table
CREATE TABLE "inventory_item_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "inventory_item_id" uuid NOT NULL,
  "warehouse_id" uuid NULL,
  "supplier_id" uuid NULL,
  "hazard_id" uuid NULL,
  "debit_account_id" uuid NULL,
  "debit" numeric(15,2) NULL DEFAULT 0,
  "credit_account_id" uuid NULL,
  "credit" numeric(15,2) NULL DEFAULT 0,
  "quantity" numeric(15,2) NOT NULL,
  "weight" numeric(15,2) NULL,
  "unit" character varying(50) NULL,
  "dimensions_width" numeric(15,2) NULL,
  "dimensions_length" numeric(15,2) NULL,
  "dimensions_height" numeric(15,2) NULL,
  "shipping_category" bigint NULL,
  "description" text NULL,
  "status_in" character varying(50) NULL,
  "status_out" character varying(50) NULL,
  "current_location" character varying(255) NULL,
  "longitude" numeric(11,8) NULL,
  "latitude" numeric(10,8) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_item_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_item_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_item_entries_credit_account" FOREIGN KEY ("credit_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_inventory_item_entries_debit_account" FOREIGN KEY ("debit_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_inventory_item_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_item_entries_hazard" FOREIGN KEY ("hazard_id") REFERENCES "inventory_hazards" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_inventory_item_entries_inventory_item" FOREIGN KEY ("inventory_item_id") REFERENCES "inventory_items" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_item_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_item_entries_supplier" FOREIGN KEY ("supplier_id") REFERENCES "inventory_suppliers" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_inventory_item_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_item_entries_warehouse" FOREIGN KEY ("warehouse_id") REFERENCES "inventory_warehouses" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_inventory_item_entries_deleted_at" to table: "inventory_item_entries"
CREATE INDEX "idx_inventory_item_entries_deleted_at" ON "inventory_item_entries" ("deleted_at");
-- create index "idx_org_branch_item_entry" to table: "inventory_item_entries"
CREATE INDEX "idx_org_branch_item_entry" ON "inventory_item_entries" ("organization_id", "branch_id");
-- create "inventory_tags" table
CREATE TABLE "inventory_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "inventory_item_id" uuid NULL,
  "name" character varying(50) NOT NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_inventory_items_tags" FOREIGN KEY ("inventory_item_id") REFERENCES "inventory_items" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_inventory_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_inventory_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_inventory_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_inventory_tags_deleted_at" to table: "inventory_tags"
CREATE INDEX "idx_inventory_tags_deleted_at" ON "inventory_tags" ("deleted_at");
-- create index "idx_organization_branch_inventory_tag" to table: "inventory_tags"
CREATE INDEX "idx_organization_branch_inventory_tag" ON "inventory_tags" ("organization_id", "branch_id");
-- create "invitation_codes" table
CREATE TABLE "invitation_codes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "user_type" character varying(255) NOT NULL,
  "code" character varying(255) NOT NULL,
  "expiration_date" timestamptz NOT NULL,
  "max_use" bigint NOT NULL,
  "current_use" bigint NULL DEFAULT 0,
  "description" text NULL,
  "permission_name" character varying(255) NOT NULL,
  "permission_description" character varying(255) NOT NULL,
  "permissions" character varying(255)[] NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_invitation_codes_code" UNIQUE ("code"),
  CONSTRAINT "fk_branches_invitation_codes" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_invitation_codes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_invitation_codes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_invitation_codes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_organizations_invitation_codes" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_branch_org_invitation_code" to table: "invitation_codes"
CREATE INDEX "idx_branch_org_invitation_code" ON "invitation_codes" ("organization_id", "branch_id");
-- create index "idx_invitation_codes_deleted_at" to table: "invitation_codes"
CREATE INDEX "idx_invitation_codes_deleted_at" ON "invitation_codes" ("deleted_at");
-- create "journal_vouchers" table
CREATE TABLE "journal_vouchers" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "cash_voucher_number" character varying(255) NULL,
  "date" timestamptz NOT NULL DEFAULT now(),
  "description" text NULL,
  "reference" character varying(255) NULL,
  "status" character varying(50) NULL DEFAULT 'draft',
  "posted_at" timestamp NULL,
  "posted_by_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "printed_date" timestamp NULL,
  "printed_by_id" uuid NULL,
  "print_number" bigint NULL DEFAULT 0,
  "approved_date" timestamp NULL,
  "approved_by_id" uuid NULL,
  "released_date" timestamp NULL,
  "released_by_id" uuid NULL,
  "total_debit" numeric NULL,
  "total_credit" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_journal_vouchers_approved_by" FOREIGN KEY ("approved_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_vouchers_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_vouchers_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_vouchers_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_vouchers_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_vouchers_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_vouchers_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_vouchers_posted_by" FOREIGN KEY ("posted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_vouchers_printed_by" FOREIGN KEY ("printed_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_vouchers_released_by" FOREIGN KEY ("released_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_vouchers_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_vouchers_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_journal_vouchers_deleted_at" to table: "journal_vouchers"
CREATE INDEX "idx_journal_vouchers_deleted_at" ON "journal_vouchers" ("deleted_at");
-- create index "idx_organization_branch_journal_voucher" to table: "journal_vouchers"
CREATE INDEX "idx_organization_branch_journal_voucher" ON "journal_vouchers" ("organization_id", "branch_id");
-- create "journal_voucher_entries" table
CREATE TABLE "journal_voucher_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "journal_voucher_id" uuid NOT NULL,
  "loan_transaction_id" uuid NULL,
  "description" text NULL,
  "debit" numeric NULL,
  "credit" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_journal_voucher_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_voucher_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_voucher_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_voucher_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_voucher_entries_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_voucher_entries_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_voucher_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_journal_voucher_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_voucher_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_vouchers_journal_voucher_entries" FOREIGN KEY ("journal_voucher_id") REFERENCES "journal_vouchers" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_journal_voucher_entries_deleted_at" to table: "journal_voucher_entries"
CREATE INDEX "idx_journal_voucher_entries_deleted_at" ON "journal_voucher_entries" ("deleted_at");
-- create index "idx_organization_branch_journal_voucher_entry" to table: "journal_voucher_entries"
CREATE INDEX "idx_organization_branch_journal_voucher_entry" ON "journal_voucher_entries" ("organization_id", "branch_id");
-- create "journal_voucher_tags" table
CREATE TABLE "journal_voucher_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "journal_voucher_id" uuid NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_journal_voucher_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_voucher_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_voucher_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_voucher_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_journal_voucher_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_journal_vouchers_journal_voucher_tags" FOREIGN KEY ("journal_voucher_id") REFERENCES "journal_vouchers" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_journal_voucher_tags_deleted_at" to table: "journal_voucher_tags"
CREATE INDEX "idx_journal_voucher_tags_deleted_at" ON "journal_voucher_tags" ("deleted_at");
-- create index "idx_organization_branch_journal_voucher_tag" to table: "journal_voucher_tags"
CREATE INDEX "idx_organization_branch_journal_voucher_tag" ON "journal_voucher_tags" ("organization_id", "branch_id");
-- create "loan_accounts" table
CREATE TABLE "loan_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "account_id" uuid NULL,
  "account_history_id" uuid NULL,
  "amount" numeric NULL DEFAULT 0,
  "total_add" numeric NULL DEFAULT 0,
  "total_add_count" bigint NULL DEFAULT 0,
  "total_deduction" numeric NULL DEFAULT 0,
  "total_deduction_count" bigint NULL DEFAULT 0,
  "total_payment" numeric NULL DEFAULT 0,
  "total_payment_count" bigint NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_accounts_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_accounts_account_history" FOREIGN KEY ("account_history_id") REFERENCES "account_histories" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_accounts" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_account_loan_transaction" to table: "loan_accounts"
CREATE INDEX "idx_loan_account_loan_transaction" ON "loan_accounts" ("loan_transaction_id");
-- create index "idx_loan_accounts_deleted_at" to table: "loan_accounts"
CREATE INDEX "idx_loan_accounts_deleted_at" ON "loan_accounts" ("deleted_at");
-- create index "idx_organization_branch_loan_account" to table: "loan_accounts"
CREATE INDEX "idx_organization_branch_loan_account" ON "loan_accounts" ("organization_id", "branch_id");
-- create "loan_clearance_analyses" table
CREATE TABLE "loan_clearance_analyses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "regular_deduction_description" text NULL,
  "regular_deduction_amount" numeric NULL,
  "balances_description" text NULL,
  "balances_amount" numeric NULL,
  "balances_count" bigint NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_clearance_analyses_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_clearance_analyses_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_clearance_analyses_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_clearance_analyses_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_clearance_analyses_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_clearance_analysis" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_clearance_analyses_deleted_at" to table: "loan_clearance_analyses"
CREATE INDEX "idx_loan_clearance_analyses_deleted_at" ON "loan_clearance_analyses" ("deleted_at");
-- create index "idx_organization_branch_loan_clearance_analysis" to table: "loan_clearance_analyses"
CREATE INDEX "idx_organization_branch_loan_clearance_analysis" ON "loan_clearance_analyses" ("organization_id", "branch_id");
-- create "loan_clearance_analysis_institutions" table
CREATE TABLE "loan_clearance_analysis_institutions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_clearance_analysis_institutions_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_clearance_analysis_institutions_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_clearance_analysis_institutions_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_clearance_analysis_institutions_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_clearance_analysis_institutions_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_clearance_analysis_institution" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_clearance_analysis_institutions_deleted_at" to table: "loan_clearance_analysis_institutions"
CREATE INDEX "idx_loan_clearance_analysis_institutions_deleted_at" ON "loan_clearance_analysis_institutions" ("deleted_at");
-- create index "idx_organization_branch_loan_clearance_analysis_institution" to table: "loan_clearance_analysis_institutions"
CREATE INDEX "idx_organization_branch_loan_clearance_analysis_institution" ON "loan_clearance_analysis_institutions" ("organization_id", "branch_id");
-- create "loan_comaker_members" table
CREATE TABLE "loan_comaker_members" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "description" text NULL,
  "amount" numeric NULL,
  "months_count" bigint NULL,
  "year_count" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_comaker_members_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_comaker_members_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_comaker_members_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_comaker_members_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_comaker_members_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_comaker_members_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_comaker_members_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_comaker_members_deleted_at" to table: "loan_comaker_members"
CREATE INDEX "idx_loan_comaker_members_deleted_at" ON "loan_comaker_members" ("deleted_at");
-- create index "idx_organization_branch_loan_comaker_member" to table: "loan_comaker_members"
CREATE INDEX "idx_organization_branch_loan_comaker_member" ON "loan_comaker_members" ("organization_id", "branch_id");
-- create "loan_guaranteed_fund_per_months" table
CREATE TABLE "loan_guaranteed_fund_per_months" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "month" bigint NULL DEFAULT 0,
  "loan_guaranteed_fund" bigint NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_guaranteed_fund_per_months_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_guaranteed_fund_per_months_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_guaranteed_fund_per_months_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_guaranteed_fund_per_months_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_guaranteed_fund_per_months_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_guaranteed_fund_per_months_deleted_at" to table: "loan_guaranteed_fund_per_months"
CREATE INDEX "idx_loan_guaranteed_fund_per_months_deleted_at" ON "loan_guaranteed_fund_per_months" ("deleted_at");
-- create index "idx_organization_branch_loan_guaranteed_fund_per_month" to table: "loan_guaranteed_fund_per_months"
CREATE INDEX "idx_organization_branch_loan_guaranteed_fund_per_month" ON "loan_guaranteed_fund_per_months" ("organization_id", "branch_id");
-- create "loan_guaranteed_funds" table
CREATE TABLE "loan_guaranteed_funds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "scheme_number" bigint NOT NULL,
  "increasing_rate" numeric NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "uni_loan_guaranteed_funds_scheme_number" UNIQUE ("scheme_number"),
  CONSTRAINT "fk_loan_guaranteed_funds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_guaranteed_funds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_guaranteed_funds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_guaranteed_funds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_guaranteed_funds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_loan_guaranteed_funds_deleted_at" to table: "loan_guaranteed_funds"
CREATE INDEX "idx_loan_guaranteed_funds_deleted_at" ON "loan_guaranteed_funds" ("deleted_at");
-- create index "idx_organization_branch_loan_guaranteed_fund" to table: "loan_guaranteed_funds"
CREATE INDEX "idx_organization_branch_loan_guaranteed_fund" ON "loan_guaranteed_funds" ("organization_id", "branch_id");
-- create "loan_tags" table
CREATE TABLE "loan_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NULL,
  "name" character varying(50) NOT NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_tags" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_tags_deleted_at" to table: "loan_tags"
CREATE INDEX "idx_loan_tags_deleted_at" ON "loan_tags" ("deleted_at");
-- create index "idx_organization_branch_loan_tag" to table: "loan_tags"
CREATE INDEX "idx_organization_branch_loan_tag" ON "loan_tags" ("organization_id", "branch_id");
-- create "loan_terms_and_condition_amount_receipts" table
CREATE TABLE "loan_terms_and_condition_amount_receipts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "amount" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_terms_and_condition_amount_receipts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_terms_and_condition_amount_receipt" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_terms_and_condition_amount_receipts_deleted_at" to table: "loan_terms_and_condition_amount_receipts"
CREATE INDEX "idx_loan_terms_and_condition_amount_receipts_deleted_at" ON "loan_terms_and_condition_amount_receipts" ("deleted_at");
-- create index "idx_organization_branch_loan_terms_and_condition_amount_receipt" to table: "loan_terms_and_condition_amount_receipts"
CREATE INDEX "idx_organization_branch_loan_terms_and_condition_amount_receipt" ON "loan_terms_and_condition_amount_receipts" ("organization_id", "branch_id");
-- create "loan_terms_and_condition_suggested_payments" table
CREATE TABLE "loan_terms_and_condition_suggested_payments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_terms_and_condition_suggested_payments_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_terms_and_condition_suggested_payments_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_terms_and_condition_suggested_payments_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_terms_and_condition_suggested_payments_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_terms_and_condition_suggested_payments_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_terms_and_condition_suggested_payment" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_terms_and_condition_suggested_payments_deleted_at" to table: "loan_terms_and_condition_suggested_payments"
CREATE INDEX "idx_loan_terms_and_condition_suggested_payments_deleted_at" ON "loan_terms_and_condition_suggested_payments" ("deleted_at");
-- create index "idx_organization_branch_loan_terms_and_condition_suggested_paym" to table: "loan_terms_and_condition_suggested_payments"
CREATE INDEX "idx_organization_branch_loan_terms_and_condition_suggested_paym" ON "loan_terms_and_condition_suggested_payments" ("organization_id", "branch_id");
-- create "loan_transaction_entries" table
CREATE TABLE "loan_transaction_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "loan_transaction_id" uuid NOT NULL,
  "index" bigint NULL DEFAULT 0,
  "type" character varying(20) NOT NULL DEFAULT 'static',
  "is_add_on" boolean NOT NULL DEFAULT false,
  "account_id" uuid NULL,
  "automatic_loan_deduction_id" uuid NULL,
  "is_automatic_loan_deduction_deleted" boolean NOT NULL DEFAULT false,
  "name" character varying(255) NULL,
  "description" character varying(500) NULL,
  "credit" numeric NULL,
  "debit" numeric NULL,
  "amount" numeric NULL DEFAULT 0,
  "member_profile_id" uuid NULL,
  "member_loan_transaction_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_loan_transaction_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_automatic_loan_deduction" FOREIGN KEY ("automatic_loan_deduction_id") REFERENCES "automatic_loan_deductions" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_transaction_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_member_loan_transaction" FOREIGN KEY ("member_loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transaction_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_loan_transaction_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_loan_transactions_loan_transaction_entries" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_loan_transaction_entries_deleted_at" to table: "loan_transaction_entries"
CREATE INDEX "idx_loan_transaction_entries_deleted_at" ON "loan_transaction_entries" ("deleted_at");
-- create index "idx_loan_transaction_entries_member_loan_transaction_id" to table: "loan_transaction_entries"
CREATE INDEX "idx_loan_transaction_entries_member_loan_transaction_id" ON "loan_transaction_entries" ("member_loan_transaction_id");
-- create index "idx_loan_transaction_entries_member_profile_id" to table: "loan_transaction_entries"
CREATE INDEX "idx_loan_transaction_entries_member_profile_id" ON "loan_transaction_entries" ("member_profile_id");
-- create index "idx_loan_transaction_entry_loan_transaction" to table: "loan_transaction_entries"
CREATE INDEX "idx_loan_transaction_entry_loan_transaction" ON "loan_transaction_entries" ("loan_transaction_id");
-- create index "idx_organization_branch_loan_transaction_entry" to table: "loan_transaction_entries"
CREATE INDEX "idx_organization_branch_loan_transaction_entry" ON "loan_transaction_entries" ("organization_id", "branch_id");
-- create "member_addresses" table
CREATE TABLE "member_addresses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "label" character varying(255) NOT NULL DEFAULT 'home',
  "city" character varying(255) NOT NULL,
  "country_code" character varying(5) NOT NULL,
  "postal_code" character varying(255) NULL,
  "province_state" character varying(255) NULL,
  "barangay" character varying(255) NULL,
  "landmark" character varying(255) NULL,
  "address" character varying(255) NOT NULL,
  "latitude" double precision NULL,
  "longitude" double precision NULL,
  "area_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_addresses_area" FOREIGN KEY ("area_id") REFERENCES "areas" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_addresses_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_addresses_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_addresses_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_addresses_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_addresses_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_addresses" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_addresses_deleted_at" to table: "member_addresses"
CREATE INDEX "idx_member_addresses_deleted_at" ON "member_addresses" ("deleted_at");
-- create index "idx_organization_branch_member_address" to table: "member_addresses"
CREATE INDEX "idx_organization_branch_member_address" ON "member_addresses" ("organization_id", "branch_id");
-- create "member_assets" table
CREATE TABLE "member_assets" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "entry_date" timestamptz NOT NULL,
  "description" text NULL,
  "cost" numeric(20,6) NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_assets_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_assets_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_assets_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_assets_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_assets_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_assets_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_assets" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_assets_deleted_at" to table: "member_assets"
CREATE INDEX "idx_member_assets_deleted_at" ON "member_assets" ("deleted_at");
-- create index "idx_organization_branch_member_asset" to table: "member_assets"
CREATE INDEX "idx_organization_branch_member_asset" ON "member_assets" ("organization_id", "branch_id");
-- create "member_bank_cards" table
CREATE TABLE "member_bank_cards" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "bank_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "account_number" character varying(50) NOT NULL,
  "card_name" character varying(50) NOT NULL,
  "expiration_date" timestamptz NOT NULL,
  "is_default" boolean NOT NULL DEFAULT false,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_bank_cards_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_bank_cards_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_bank_cards_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_bank_cards_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_bank_cards_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT "fk_member_bank_cards_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_bank_cards_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_bank_cards_deleted_at" to table: "member_bank_cards"
CREATE INDEX "idx_member_bank_cards_deleted_at" ON "member_bank_cards" ("deleted_at");
-- create index "idx_organization_branch_member_card" to table: "member_bank_cards"
CREATE INDEX "idx_organization_branch_member_card" ON "member_bank_cards" ("organization_id", "branch_id");
-- create "member_center_histories" table
CREATE TABLE "member_center_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_center_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_center_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_center_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_center_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_center_histories_member_center" FOREIGN KEY ("member_center_id") REFERENCES "member_centers" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_center_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_center_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_center_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_center_histories_deleted_at" to table: "member_center_histories"
CREATE INDEX "idx_member_center_histories_deleted_at" ON "member_center_histories" ("deleted_at");
-- create index "idx_organization_branch_member_center_history" to table: "member_center_histories"
CREATE INDEX "idx_organization_branch_member_center_history" ON "member_center_histories" ("organization_id", "branch_id");
-- create "member_classification_histories" table
CREATE TABLE "member_classification_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_classification_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_classification_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classification_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classification_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_classification_histories_member_classification" FOREIGN KEY ("member_classification_id") REFERENCES "member_classifications" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_classification_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_classification_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_classification_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_classification_histories_deleted_at" to table: "member_classification_histories"
CREATE INDEX "idx_member_classification_histories_deleted_at" ON "member_classification_histories" ("deleted_at");
-- create index "idx_organization_branch_member_classification_history" to table: "member_classification_histories"
CREATE INDEX "idx_organization_branch_member_classification_history" ON "member_classification_histories" ("organization_id", "branch_id");
-- create "member_close_remarks" table
CREATE TABLE "member_close_remarks" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "reason" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_close_remarks_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_close_remarks_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_close_remarks_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_close_remarks_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_close_remarks_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_close_remarks" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_close_remarks_deleted_at" to table: "member_close_remarks"
CREATE INDEX "idx_member_close_remarks_deleted_at" ON "member_close_remarks" ("deleted_at");
-- create index "idx_organization_branch_member_close_remark" to table: "member_close_remarks"
CREATE INDEX "idx_organization_branch_member_close_remark" ON "member_close_remarks" ("organization_id", "branch_id");
-- create "member_contact_references" table
CREATE TABLE "member_contact_references" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "contact_number" character varying(30) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_contact_references_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_contact_references_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_contact_references_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_contact_references_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_contact_references_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_contact_references" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_contact_references_deleted_at" to table: "member_contact_references"
CREATE INDEX "idx_member_contact_references_deleted_at" ON "member_contact_references" ("deleted_at");
-- create index "idx_organization_branch_member_contact_reference" to table: "member_contact_references"
CREATE INDEX "idx_organization_branch_member_contact_reference" ON "member_contact_references" ("organization_id", "branch_id");
-- create "member_damayan_extension_entries" table
CREATE TABLE "member_damayan_extension_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "birthdate" timestamp NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_damayan_extension_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_damayan_extension_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_damayan_extension_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_damayan_extension_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_damayan_extension_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_damayan_extension_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_damayan_extension_entries_deleted_at" to table: "member_damayan_extension_entries"
CREATE INDEX "idx_member_damayan_extension_entries_deleted_at" ON "member_damayan_extension_entries" ("deleted_at");
-- create index "idx_organization_branch_member_damayan_extension_entry" to table: "member_damayan_extension_entries"
CREATE INDEX "idx_organization_branch_member_damayan_extension_entry" ON "member_damayan_extension_entries" ("organization_id", "branch_id");
-- create "member_deduction_entries" table
CREATE TABLE "member_deduction_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "description" text NULL,
  "membership_date" timestamp NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_deduction_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_deduction_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_deduction_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_deduction_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_deduction_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_deduction_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_deduction_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_deduction_entries_deleted_at" to table: "member_deduction_entries"
CREATE INDEX "idx_member_deduction_entries_deleted_at" ON "member_deduction_entries" ("deleted_at");
-- create index "idx_organization_branch_member_deduction_entry" to table: "member_deduction_entries"
CREATE INDEX "idx_organization_branch_member_deduction_entry" ON "member_deduction_entries" ("organization_id", "branch_id");
-- create "member_department_histories" table
CREATE TABLE "member_department_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_department_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_department_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_department_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_department_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_department_histories_member_department" FOREIGN KEY ("member_department_id") REFERENCES "member_departments" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_department_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_department_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_department_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_department_histories_deleted_at" to table: "member_department_histories"
CREATE INDEX "idx_member_department_histories_deleted_at" ON "member_department_histories" ("deleted_at");
-- create index "idx_organization_branch_member_department_history" to table: "member_department_histories"
CREATE INDEX "idx_organization_branch_member_department_history" ON "member_department_histories" ("organization_id", "branch_id");
-- create "member_educational_attainments" table
CREATE TABLE "member_educational_attainments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "school_name" character varying(255) NULL,
  "school_year" bigint NULL,
  "program_course" character varying(255) NULL,
  "educational_attainment" character varying(255) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_educational_attainments_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_educational_attainments_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_educational_attainments_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_educational_attainments_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_educational_attainments_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_educational_attainments" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_educational_attainments_deleted_at" to table: "member_educational_attainments"
CREATE INDEX "idx_member_educational_attainments_deleted_at" ON "member_educational_attainments" ("deleted_at");
-- create index "idx_organization_branch_member_educational_attainment" to table: "member_educational_attainments"
CREATE INDEX "idx_organization_branch_member_educational_attainment" ON "member_educational_attainments" ("organization_id", "branch_id");
-- create "member_expenses" table
CREATE TABLE "member_expenses" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "amount" numeric(20,6) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_expenses_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_expenses_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_expenses_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_expenses_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_expenses_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_expenses" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_expenses_deleted_at" to table: "member_expenses"
CREATE INDEX "idx_member_expenses_deleted_at" ON "member_expenses" ("deleted_at");
-- create index "idx_organization_branch_member_expense" to table: "member_expenses"
CREATE INDEX "idx_organization_branch_member_expense" ON "member_expenses" ("organization_id", "branch_id");
-- create "member_gender_histories" table
CREATE TABLE "member_gender_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_gender_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_gender_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_gender_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_gender_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_gender_histories_member_gender" FOREIGN KEY ("member_gender_id") REFERENCES "member_genders" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_gender_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_gender_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_gender_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_gender_histories_deleted_at" to table: "member_gender_histories"
CREATE INDEX "idx_member_gender_histories_deleted_at" ON "member_gender_histories" ("deleted_at");
-- create index "idx_organization_branch_member_gender_history" to table: "member_gender_histories"
CREATE INDEX "idx_organization_branch_member_gender_history" ON "member_gender_histories" ("organization_id", "branch_id");
-- create "member_government_benefits" table
CREATE TABLE "member_government_benefits" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "front_media_id" uuid NULL,
  "back_media_id" uuid NULL,
  "country_code" character varying(4) NULL,
  "description" text NULL,
  "name" character varying(254) NULL,
  "value" character varying(254) NULL DEFAULT '',
  "expiry_date" date NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_government_benefits_back_media" FOREIGN KEY ("back_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_government_benefits_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_government_benefits_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_government_benefits_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_government_benefits_front_media" FOREIGN KEY ("front_media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_government_benefits_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_government_benefits_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_government_benefits" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_government_benefits_deleted_at" to table: "member_government_benefits"
CREATE INDEX "idx_member_government_benefits_deleted_at" ON "member_government_benefits" ("deleted_at");
-- create index "idx_organization_branch_member_government_benefits" to table: "member_government_benefits"
CREATE INDEX "idx_organization_branch_member_government_benefits" ON "member_government_benefits" ("organization_id", "branch_id");
-- create "member_group_histories" table
CREATE TABLE "member_group_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_group_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_group_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_group_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_group_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_group_histories_member_group" FOREIGN KEY ("member_group_id") REFERENCES "member_groups" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_group_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_group_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_group_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_group_histories_deleted_at" to table: "member_group_histories"
CREATE INDEX "idx_member_group_histories_deleted_at" ON "member_group_histories" ("deleted_at");
-- create index "idx_organization_branch_member_group_history" to table: "member_group_histories"
CREATE INDEX "idx_organization_branch_member_group_history" ON "member_group_histories" ("organization_id", "branch_id");
-- create "member_incomes" table
CREATE TABLE "member_incomes" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "member_profile_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "source" character varying(255) NULL,
  "amount" numeric(20,6) NULL,
  "release_date" timestamp NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_incomes_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_incomes_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_incomes_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_incomes_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_incomes_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_incomes_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profiles_member_incomes" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_member_incomes_deleted_at" to table: "member_incomes"
CREATE INDEX "idx_member_incomes_deleted_at" ON "member_incomes" ("deleted_at");
-- create index "idx_organization_branch_member_income" to table: "member_incomes"
CREATE INDEX "idx_organization_branch_member_income" ON "member_incomes" ("organization_id", "branch_id");
-- create "member_mutual_fund_histories" table
CREATE TABLE "member_mutual_fund_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "title" character varying(255) NULL,
  "amount" numeric(20,6) NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_mutual_fund_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_mutual_fund_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_mutual_fund_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_member_mutual_fund_histories_deleted_at" to table: "member_mutual_fund_histories"
CREATE INDEX "idx_member_mutual_fund_histories_deleted_at" ON "member_mutual_fund_histories" ("deleted_at");
-- create index "idx_organization_branch_member_mutual_fund_history" to table: "member_mutual_fund_histories"
CREATE INDEX "idx_organization_branch_member_mutual_fund_history" ON "member_mutual_fund_histories" ("organization_id", "branch_id");
-- create "member_occupation_histories" table
CREATE TABLE "member_occupation_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_occupation_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_occupation_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_occupation_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_occupation_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_occupation_histories_member_occupation" FOREIGN KEY ("member_occupation_id") REFERENCES "member_occupations" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_occupation_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_occupation_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_occupation_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_occupation_histories_deleted_at" to table: "member_occupation_histories"
CREATE INDEX "idx_member_occupation_histories_deleted_at" ON "member_occupation_histories" ("deleted_at");
-- create index "idx_organization_branch_member_occupation_history" to table: "member_occupation_histories"
CREATE INDEX "idx_organization_branch_member_occupation_history" ON "member_occupation_histories" ("organization_id", "branch_id");
-- create "member_other_information_entries" table
CREATE TABLE "member_other_information_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "entry_date" timestamp NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_other_information_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_other_information_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_other_information_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_other_information_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_other_information_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_other_information_entries_deleted_at" to table: "member_other_information_entries"
CREATE INDEX "idx_member_other_information_entries_deleted_at" ON "member_other_information_entries" ("deleted_at");
-- create index "idx_organization_branch_member_other_information_entry" to table: "member_other_information_entries"
CREATE INDEX "idx_organization_branch_member_other_information_entry" ON "member_other_information_entries" ("organization_id", "branch_id");
-- create "member_profile_archives" table
CREATE TABLE "member_profile_archives" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NULL,
  "branch_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "category" character varying(100) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_profile_archives_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_archives_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_archives_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_archives_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_archives_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_archives_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_archives_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_profile_archives_category" to table: "member_profile_archives"
CREATE INDEX "idx_member_profile_archives_category" ON "member_profile_archives" ("category");
-- create index "idx_member_profile_archives_deleted_at" to table: "member_profile_archives"
CREATE INDEX "idx_member_profile_archives_deleted_at" ON "member_profile_archives" ("deleted_at");
-- create index "idx_organization_branch_member_profile_media" to table: "member_profile_archives"
CREATE INDEX "idx_organization_branch_member_profile_media" ON "member_profile_archives" ("organization_id", "branch_id");
-- create "member_profile_media" table
CREATE TABLE "member_profile_media" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NULL,
  "branch_id" uuid NULL,
  "member_profile_id" uuid NULL,
  "media_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_profile_media_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_media_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_media_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_media_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_profile_media_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_media_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_profile_media_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_profile_media_deleted_at" to table: "member_profile_media"
CREATE INDEX "idx_member_profile_media_deleted_at" ON "member_profile_media" ("deleted_at");
-- create "member_relative_accounts" table
CREATE TABLE "member_relative_accounts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "relative_member_profile_id" uuid NOT NULL,
  "family_relationship" character varying(255) NOT NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_profiles_member_relative_accounts" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_member_relative_accounts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_relative_accounts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_relative_accounts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_relative_accounts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_relative_accounts_relative_member_profile" FOREIGN KEY ("relative_member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_relative_accounts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_relative_accounts_deleted_at" to table: "member_relative_accounts"
CREATE INDEX "idx_member_relative_accounts_deleted_at" ON "member_relative_accounts" ("deleted_at");
-- create index "idx_organization_branch_member_relative_account" to table: "member_relative_accounts"
CREATE INDEX "idx_organization_branch_member_relative_account" ON "member_relative_accounts" ("organization_id", "branch_id");
-- create "member_type_histories" table
CREATE TABLE "member_type_histories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_type_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_type_histories_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_type_histories_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_type_histories_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_type_histories_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_type_histories_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_member_type_histories_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_type_histories_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_member_type_histories_deleted_at" to table: "member_type_histories"
CREATE INDEX "idx_member_type_histories_deleted_at" ON "member_type_histories" ("deleted_at");
-- create index "idx_organization_branch_member_type_history" to table: "member_type_histories"
CREATE INDEX "idx_organization_branch_member_type_history" ON "member_type_histories" ("organization_id", "branch_id");
-- create "member_verifications" table
CREATE TABLE "member_verifications" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "verified_by_user_id" uuid NULL,
  "status" character varying(50) NOT NULL DEFAULT 'pending',
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_member_verifications_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_verifications_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_verifications_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_verifications_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_verifications_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_member_verifications_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_member_verifications_verified_by_user" FOREIGN KEY ("verified_by_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_member_verifications_deleted_at" to table: "member_verifications"
CREATE INDEX "idx_member_verifications_deleted_at" ON "member_verifications" ("deleted_at");
-- create index "idx_organization_branch_member_verification" to table: "member_verifications"
CREATE INDEX "idx_organization_branch_member_verification" ON "member_verifications" ("organization_id", "branch_id");
-- create "mutual_funds" table
CREATE TABLE "mutual_funds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "member_type_id" uuid NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "date_of_death" timestamptz NOT NULL,
  "extension_only" boolean NOT NULL DEFAULT false,
  "amount" numeric NOT NULL,
  "computation_type" character varying(50) NOT NULL,
  "total_amount" numeric NULL DEFAULT 0,
  "account_id" uuid NULL,
  "post_account_id" uuid NULL,
  "printed_by_user_id" uuid NULL,
  "printed_date" timestamptz NULL,
  "posted_date" timestamptz NULL,
  "posted_by_user_id" uuid NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_mutual_funds_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_funds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_funds_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_funds_post_account" FOREIGN KEY ("post_account_id") REFERENCES "accounts" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_mutual_funds_posted_by_user" FOREIGN KEY ("posted_by_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_printed_by_user" FOREIGN KEY ("printed_by_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_mutual_funds_deleted_at" to table: "mutual_funds"
CREATE INDEX "idx_mutual_funds_deleted_at" ON "mutual_funds" ("deleted_at");
-- create index "idx_organization_branch_mutual_fund" to table: "mutual_funds"
CREATE INDEX "idx_organization_branch_mutual_fund" ON "mutual_funds" ("organization_id", "branch_id");
-- create "mutual_fund_additional_members" table
CREATE TABLE "mutual_fund_additional_members" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "mutual_fund_id" uuid NOT NULL,
  "member_type_id" uuid NOT NULL,
  "number_of_members" bigint NOT NULL,
  "ratio" numeric(15,4) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_mutual_fund_additional_members_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_additional_members_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_additional_members_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_additional_members_member_type" FOREIGN KEY ("member_type_id") REFERENCES "member_types" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_additional_members_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_additional_members_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_additional_members" FOREIGN KEY ("mutual_fund_id") REFERENCES "mutual_funds" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_member_type_additional" to table: "mutual_fund_additional_members"
CREATE INDEX "idx_member_type_additional" ON "mutual_fund_additional_members" ("member_type_id");
-- create index "idx_mutual_fund_additional_members" to table: "mutual_fund_additional_members"
CREATE INDEX "idx_mutual_fund_additional_members" ON "mutual_fund_additional_members" ("mutual_fund_id");
-- create index "idx_mutual_fund_additional_members_deleted_at" to table: "mutual_fund_additional_members"
CREATE INDEX "idx_mutual_fund_additional_members_deleted_at" ON "mutual_fund_additional_members" ("deleted_at");
-- create index "idx_organization_branch_mutual_fund_additional" to table: "mutual_fund_additional_members"
CREATE INDEX "idx_organization_branch_mutual_fund_additional" ON "mutual_fund_additional_members" ("organization_id", "branch_id");
-- create "mutual_fund_entries" table
CREATE TABLE "mutual_fund_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "mutual_fund_id" uuid NOT NULL,
  "member_profile_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "amount" numeric(15,4) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_mutual_fund_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_entries_mutual_fund" FOREIGN KEY ("mutual_fund_id") REFERENCES "mutual_funds" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_mutual_fund_entries_deleted_at" to table: "mutual_fund_entries"
CREATE INDEX "idx_mutual_fund_entries_deleted_at" ON "mutual_fund_entries" ("deleted_at");
-- create index "idx_mutual_fund_entry_account" to table: "mutual_fund_entries"
CREATE INDEX "idx_mutual_fund_entry_account" ON "mutual_fund_entries" ("account_id");
-- create index "idx_mutual_fund_entry_member" to table: "mutual_fund_entries"
CREATE INDEX "idx_mutual_fund_entry_member" ON "mutual_fund_entries" ("member_profile_id");
-- create index "idx_mutual_fund_entry_mutual_fund" to table: "mutual_fund_entries"
CREATE INDEX "idx_mutual_fund_entry_mutual_fund" ON "mutual_fund_entries" ("mutual_fund_id");
-- create index "idx_organization_branch_mutual_fund_entry" to table: "mutual_fund_entries"
CREATE INDEX "idx_organization_branch_mutual_fund_entry" ON "mutual_fund_entries" ("organization_id", "branch_id");
-- create "mutual_fund_tables" table
CREATE TABLE "mutual_fund_tables" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "mutual_fund_id" uuid NOT NULL,
  "month_from" bigint NOT NULL,
  "month_to" bigint NOT NULL,
  "amount" numeric(15,4) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_mutual_fund_tables_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_tables_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_tables_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_fund_tables_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_mutual_fund_tables_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_mutual_funds_mutual_fund_tables" FOREIGN KEY ("mutual_fund_id") REFERENCES "mutual_funds" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_mutual_fund_table" to table: "mutual_fund_tables"
CREATE INDEX "idx_mutual_fund_table" ON "mutual_fund_tables" ("mutual_fund_id");
-- create index "idx_mutual_fund_tables_deleted_at" to table: "mutual_fund_tables"
CREATE INDEX "idx_mutual_fund_tables_deleted_at" ON "mutual_fund_tables" ("deleted_at");
-- create index "idx_organization_branch_mutual_fund_table" to table: "mutual_fund_tables"
CREATE INDEX "idx_organization_branch_mutual_fund_table" ON "mutual_fund_tables" ("organization_id", "branch_id");
-- create "notifications" table
CREATE TABLE "notifications" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "user_id" uuid NOT NULL,
  "recipient_id" uuid NULL,
  "title" character varying(255) NOT NULL,
  "description" text NOT NULL,
  "is_viewed" boolean NULL DEFAULT false,
  "notification_type" character varying(50) NOT NULL,
  "user_type" character varying(50) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_notifications_recipient" FOREIGN KEY ("recipient_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_users_notification" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_notifications_deleted_at" to table: "notifications"
CREATE INDEX "idx_notifications_deleted_at" ON "notifications" ("deleted_at");
-- create "online_remittances" table
CREATE TABLE "online_remittances" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "bank_id" uuid NOT NULL,
  "media_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "currency_id" uuid NOT NULL,
  "reference_number" character varying(255) NULL,
  "amount" numeric NOT NULL,
  "account_name" character varying(255) NULL,
  "date_entry" timestamp NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_online_remittances_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_online_remittances_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_online_remittances_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_online_remittances_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_online_remittances_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_online_remittances_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_online_remittances_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_online_remittances_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_online_remittances_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_online_remittances_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_online_remittances_deleted_at" to table: "online_remittances"
CREATE INDEX "idx_online_remittances_deleted_at" ON "online_remittances" ("deleted_at");
-- create index "idx_organization_branch_online_remittance" to table: "online_remittances"
CREATE INDEX "idx_organization_branch_online_remittance" ON "online_remittances" ("organization_id", "branch_id");
-- create "categories" table
CREATE TABLE "categories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "color" character varying(50) NULL,
  "icon" character varying(50) NULL,
  PRIMARY KEY ("id")
);
-- create index "idx_categories_deleted_at" to table: "categories"
CREATE INDEX "idx_categories_deleted_at" ON "categories" ("deleted_at");
-- create "organization_categories" table
CREATE TABLE "organization_categories" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "organization_id" uuid NOT NULL,
  "category_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_categories_organization_categories" FOREIGN KEY ("category_id") REFERENCES "categories" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_organizations_organization_categories" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_organization_categories_deleted_at" to table: "organization_categories"
CREATE INDEX "idx_organization_categories_deleted_at" ON "organization_categories" ("deleted_at");
-- create "organization_daily_usages" table
CREATE TABLE "organization_daily_usages" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "organization_id" uuid NOT NULL,
  "total_members" bigint NOT NULL,
  "total_branches" bigint NOT NULL,
  "total_employees" bigint NOT NULL,
  "cash_transaction_count" bigint NOT NULL,
  "check_transaction_count" bigint NOT NULL,
  "online_transaction_count" bigint NOT NULL,
  "cash_transaction_amount" numeric NOT NULL,
  "check_transaction_amount" numeric NOT NULL,
  "online_transaction_amount" numeric NOT NULL,
  "total_email_send" bigint NOT NULL,
  "total_message_send" bigint NOT NULL,
  "total_upload_size" numeric NOT NULL,
  "total_report_render_time" numeric NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_organizations_organization_daily_usage" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_organization_daily_usages_deleted_at" to table: "organization_daily_usages"
CREATE INDEX "idx_organization_daily_usages_deleted_at" ON "organization_daily_usages" ("deleted_at");
-- create "organization_media" table
CREATE TABLE "organization_media" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "organization_id" uuid NOT NULL,
  "media_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_organization_media_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_organizations_organization_medias" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_organization_media_deleted_at" to table: "organization_media"
CREATE INDEX "idx_organization_media_deleted_at" ON "organization_media" ("deleted_at");
-- create index "idx_organization_media_organization_id" to table: "organization_media"
CREATE INDEX "idx_organization_media_organization_id" ON "organization_media" ("organization_id");
-- create "other_funds" table
CREATE TABLE "other_funds" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "cash_voucher_number" character varying(255) NULL,
  "date" timestamptz NOT NULL DEFAULT now(),
  "description" text NULL,
  "reference" character varying(255) NULL,
  "status" character varying(50) NULL DEFAULT 'draft',
  "posted_at" timestamp NULL,
  "posted_by_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "transaction_batch_id" uuid NULL,
  "printed_date" timestamp NULL,
  "printed_by_id" uuid NULL,
  "print_number" bigint NULL DEFAULT 0,
  "approved_date" timestamp NULL,
  "approved_by_id" uuid NULL,
  "released_date" timestamp NULL,
  "released_by_id" uuid NULL,
  "total_debit" numeric NULL,
  "total_credit" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_other_funds_approved_by" FOREIGN KEY ("approved_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_funds_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_funds_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_funds_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_funds_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_funds_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_funds_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_funds_posted_by" FOREIGN KEY ("posted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_funds_printed_by" FOREIGN KEY ("printed_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_funds_released_by" FOREIGN KEY ("released_by_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_funds_transaction_batch" FOREIGN KEY ("transaction_batch_id") REFERENCES "transaction_batches" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_funds_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_other_fund" to table: "other_funds"
CREATE INDEX "idx_organization_branch_other_fund" ON "other_funds" ("organization_id", "branch_id");
-- create index "idx_other_funds_deleted_at" to table: "other_funds"
CREATE INDEX "idx_other_funds_deleted_at" ON "other_funds" ("deleted_at");
-- create "other_fund_entries" table
CREATE TABLE "other_fund_entries" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "account_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "employee_user_id" uuid NULL,
  "other_fund_id" uuid NOT NULL,
  "loan_transaction_id" uuid NULL,
  "description" text NULL,
  "debit" numeric NULL,
  "credit" numeric NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_other_fund_entries_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_fund_entries_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_fund_entries_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_fund_entries_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_fund_entries_employee_user" FOREIGN KEY ("employee_user_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_fund_entries_loan_transaction" FOREIGN KEY ("loan_transaction_id") REFERENCES "loan_transactions" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_fund_entries_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_other_fund_entries_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_fund_entries_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_funds_other_fund_entries" FOREIGN KEY ("other_fund_id") REFERENCES "other_funds" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_organization_branch_other_fund_entry" to table: "other_fund_entries"
CREATE INDEX "idx_organization_branch_other_fund_entry" ON "other_fund_entries" ("organization_id", "branch_id");
-- create index "idx_other_fund_entries_deleted_at" to table: "other_fund_entries"
CREATE INDEX "idx_other_fund_entries_deleted_at" ON "other_fund_entries" ("deleted_at");
-- create "other_fund_tags" table
CREATE TABLE "other_fund_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "other_fund_id" uuid NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_other_fund_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_fund_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_fund_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_fund_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_other_fund_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_other_funds_other_fund_tags" FOREIGN KEY ("other_fund_id") REFERENCES "other_funds" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_organization_branch_other_fund_tag" to table: "other_fund_tags"
CREATE INDEX "idx_organization_branch_other_fund_tag" ON "other_fund_tags" ("organization_id", "branch_id");
-- create index "idx_other_fund_tags_deleted_at" to table: "other_fund_tags"
CREATE INDEX "idx_other_fund_tags_deleted_at" ON "other_fund_tags" ("deleted_at");
-- create "permission_templates" table
CREATE TABLE "permission_templates" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "permissions" character varying[] NULL DEFAULT '{}',
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_branches_permission_templates" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_organizations_permission_templates" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_permission_templates_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_permission_templates_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_permission_templates_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_branch_org_permission_template" to table: "permission_templates"
CREATE INDEX "idx_branch_org_permission_template" ON "permission_templates" ("organization_id", "branch_id");
-- create index "idx_permission_templates_deleted_at" to table: "permission_templates"
CREATE INDEX "idx_permission_templates_deleted_at" ON "permission_templates" ("deleted_at");
-- create "post_dated_checks" table
CREATE TABLE "post_dated_checks" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "member_profile_id" uuid NULL,
  "full_name" character varying(255) NULL,
  "passbook_number" character varying(255) NULL,
  "check_number" character varying(255) NULL,
  "check_date" timestamp NULL,
  "clear_days" bigint NULL,
  "date_cleared" timestamp NULL,
  "bank_id" uuid NULL,
  "amount" numeric NULL DEFAULT 0,
  "reference_number" character varying(255) NULL,
  "official_receipt_date" timestamp NULL,
  "collateral_user_id" uuid NULL,
  "description" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_post_dated_checks_bank" FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_post_dated_checks_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_post_dated_checks_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_post_dated_checks_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_post_dated_checks_member_profile" FOREIGN KEY ("member_profile_id") REFERENCES "member_profiles" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_post_dated_checks_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_post_dated_checks_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_post_dated_check" to table: "post_dated_checks"
CREATE INDEX "idx_organization_branch_post_dated_check" ON "post_dated_checks" ("organization_id", "branch_id");
-- create index "idx_post_dated_checks_deleted_at" to table: "post_dated_checks"
CREATE INDEX "idx_post_dated_checks_deleted_at" ON "post_dated_checks" ("deleted_at");
-- create "revolving_fund_cash_counts" table
CREATE TABLE "revolving_fund_cash_counts" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "revolving_fund_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "name" character varying(100) NOT NULL,
  "bill_amount" numeric(15,2) NULL,
  "quantity" bigint NULL,
  "amount" numeric(15,2) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_revolving_fund_cash_counts_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_revolving_fund_cash_counts_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_revolving_fund_cash_counts_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_revolving_fund_cash_counts_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_revolving_fund_cash_counts_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_revolving_fund_cash_counts_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_revolving_funds_revolving_fund_cash_count" FOREIGN KEY ("revolving_fund_id") REFERENCES "revolving_funds" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_org_branch_rf_cash_count" to table: "revolving_fund_cash_counts"
CREATE INDEX "idx_org_branch_rf_cash_count" ON "revolving_fund_cash_counts" ("organization_id", "branch_id");
-- create index "idx_revolving_fund_cash_counts_deleted_at" to table: "revolving_fund_cash_counts"
CREATE INDEX "idx_revolving_fund_cash_counts_deleted_at" ON "revolving_fund_cash_counts" ("deleted_at");
-- create index "idx_revolving_fund_cash_counts_revolving_fund_id" to table: "revolving_fund_cash_counts"
CREATE INDEX "idx_revolving_fund_cash_counts_revolving_fund_id" ON "revolving_fund_cash_counts" ("revolving_fund_id");
-- create "tag_templates" table
CREATE TABLE "tag_templates" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_tag_templates_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_tag_templates_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_tag_templates_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_tag_templates_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_tag_templates_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_tag_template" to table: "tag_templates"
CREATE INDEX "idx_organization_branch_tag_template" ON "tag_templates" ("organization_id", "branch_id");
-- create index "idx_tag_templates_deleted_at" to table: "tag_templates"
CREATE INDEX "idx_tag_templates_deleted_at" ON "tag_templates" ("deleted_at");
-- create "time_deposit_types" table
CREATE TABLE "time_deposit_types" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "currency_id" uuid NOT NULL,
  "header1" bigint NULL DEFAULT 30,
  "header2" bigint NULL DEFAULT 60,
  "header3" bigint NULL DEFAULT 90,
  "header4" bigint NULL DEFAULT 120,
  "header5" bigint NULL DEFAULT 150,
  "header6" bigint NULL DEFAULT 180,
  "header7" bigint NULL DEFAULT 210,
  "header8" bigint NULL DEFAULT 240,
  "header9" bigint NULL DEFAULT 300,
  "header10" bigint NULL DEFAULT 330,
  "header11" bigint NULL DEFAULT 360,
  "name" character varying(255) NOT NULL,
  "description" text NULL,
  "pre_mature" bigint NULL DEFAULT 0,
  "pre_mature_rate" numeric NULL DEFAULT 0,
  "excess" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_time_deposit_types_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_types_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_types_currency" FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_types_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_types_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_types_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_time_deposit_type" to table: "time_deposit_types"
CREATE INDEX "idx_organization_branch_time_deposit_type" ON "time_deposit_types" ("organization_id", "branch_id");
-- create index "idx_time_deposit_types_deleted_at" to table: "time_deposit_types"
CREATE INDEX "idx_time_deposit_types_deleted_at" ON "time_deposit_types" ("deleted_at");
-- create "time_deposit_computation_pre_matures" table
CREATE TABLE "time_deposit_computation_pre_matures" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "time_deposit_type_id" uuid NOT NULL,
  "terms" bigint NULL DEFAULT 0,
  "from" bigint NULL DEFAULT 0,
  "to" bigint NULL DEFAULT 0,
  "rate" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_time_deposit_computation_pre_matures_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_computation_pre_matures_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_computation_pre_matures_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_computation_pre_matures_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_computation_pre_matures_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_types_time_deposit_computation_pre_matures" FOREIGN KEY ("time_deposit_type_id") REFERENCES "time_deposit_types" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_organization_branch_time_deposit_computation_pre_mature" to table: "time_deposit_computation_pre_matures"
CREATE INDEX "idx_organization_branch_time_deposit_computation_pre_mature" ON "time_deposit_computation_pre_matures" ("organization_id", "branch_id");
-- create index "idx_time_deposit_computation_pre_matures_deleted_at" to table: "time_deposit_computation_pre_matures"
CREATE INDEX "idx_time_deposit_computation_pre_matures_deleted_at" ON "time_deposit_computation_pre_matures" ("deleted_at");
-- create "time_deposit_computations" table
CREATE TABLE "time_deposit_computations" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "time_deposit_type_id" uuid NOT NULL,
  "minimum_amount" numeric NULL DEFAULT 0,
  "maximum_amount" numeric NULL DEFAULT 0,
  "header1" numeric NULL DEFAULT 0,
  "header2" numeric NULL DEFAULT 0,
  "header3" numeric NULL DEFAULT 0,
  "header4" numeric NULL DEFAULT 0,
  "header5" numeric NULL DEFAULT 0,
  "header6" numeric NULL DEFAULT 0,
  "header7" numeric NULL DEFAULT 0,
  "header8" numeric NULL DEFAULT 0,
  "header9" numeric NULL DEFAULT 0,
  "header10" numeric NULL DEFAULT 0,
  "header11" numeric NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_time_deposit_computations_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_computations_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_computations_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_computations_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_time_deposit_computations_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_time_deposit_types_time_deposit_computations" FOREIGN KEY ("time_deposit_type_id") REFERENCES "time_deposit_types" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- create index "idx_organization_branch_time_deposit_computation" to table: "time_deposit_computations"
CREATE INDEX "idx_organization_branch_time_deposit_computation" ON "time_deposit_computations" ("organization_id", "branch_id");
-- create index "idx_time_deposit_computations_deleted_at" to table: "time_deposit_computations"
CREATE INDEX "idx_time_deposit_computations_deleted_at" ON "time_deposit_computations" ("deleted_at");
-- create "timesheets" table
CREATE TABLE "timesheets" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "user_id" uuid NULL,
  "media_in_id" uuid NULL,
  "media_out_id" uuid NULL,
  "time_in" timestamptz NOT NULL DEFAULT now(),
  "time_out" timestamptz NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_timesheets_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_timesheets_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_timesheets_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_timesheets_media_in" FOREIGN KEY ("media_in_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_timesheets_media_out" FOREIGN KEY ("media_out_id") REFERENCES "media" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT,
  CONSTRAINT "fk_timesheets_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_timesheets_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_timesheets_user" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE RESTRICT
);
-- create index "idx_organization_branch_timesheet" to table: "timesheets"
CREATE INDEX "idx_organization_branch_timesheet" ON "timesheets" ("organization_id", "branch_id");
-- create index "idx_timesheets_deleted_at" to table: "timesheets"
CREATE INDEX "idx_timesheets_deleted_at" ON "timesheets" ("deleted_at");
-- create "transaction_tags" table
CREATE TABLE "transaction_tags" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "transaction_id" uuid NOT NULL,
  "name" character varying(50) NULL,
  "description" text NULL,
  "category" character varying(50) NULL,
  "color" character varying(20) NULL,
  "icon" character varying(20) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_transaction_tags_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transaction_tags_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transaction_tags_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_transaction_tags_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transaction_tags_transaction" FOREIGN KEY ("transaction_id") REFERENCES "transactions" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_transaction_tags_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_transaction_tag" to table: "transaction_tags"
CREATE INDEX "idx_organization_branch_transaction_tag" ON "transaction_tags" ("organization_id", "branch_id");
-- create index "idx_transaction_tags_deleted_at" to table: "transaction_tags"
CREATE INDEX "idx_transaction_tags_deleted_at" ON "transaction_tags" ("deleted_at");
-- create "user_ratings" table
CREATE TABLE "user_ratings" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "ratee_user_id" uuid NOT NULL,
  "rater_user_id" uuid NOT NULL,
  "rate" bigint NOT NULL,
  "remark" text NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_user_ratings_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_user_ratings_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_ratings_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_ratings_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_user_ratings_ratee_user" FOREIGN KEY ("ratee_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_ratings_rater_user" FOREIGN KEY ("rater_user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_user_ratings_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "chk_user_ratings_rate" CHECK ((rate >= 1) AND (rate <= 5))
);
-- create index "idx_branch_org_user_rating" to table: "user_ratings"
CREATE INDEX "idx_branch_org_user_rating" ON "user_ratings" ("organization_id", "branch_id");
-- create index "idx_user_ratings_deleted_at" to table: "user_ratings"
CREATE INDEX "idx_user_ratings_deleted_at" ON "user_ratings" ("deleted_at");
-- create "voucher_pay_tos" table
CREATE TABLE "voucher_pay_tos" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "created_by_id" uuid NULL,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "updated_by_id" uuid NULL,
  "deleted_at" timestamptz NULL,
  "deleted_by_id" uuid NULL,
  "organization_id" uuid NOT NULL,
  "branch_id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "media_id" uuid NULL,
  "description" character varying(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_voucher_pay_tos_branch" FOREIGN KEY ("branch_id") REFERENCES "branches" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_voucher_pay_tos_created_by" FOREIGN KEY ("created_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_voucher_pay_tos_deleted_by" FOREIGN KEY ("deleted_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT "fk_voucher_pay_tos_media" FOREIGN KEY ("media_id") REFERENCES "media" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT "fk_voucher_pay_tos_organization" FOREIGN KEY ("organization_id") REFERENCES "organizations" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_voucher_pay_tos_updated_by" FOREIGN KEY ("updated_by_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- create index "idx_organization_branch_voucher_pay_to" to table: "voucher_pay_tos"
CREATE INDEX "idx_organization_branch_voucher_pay_to" ON "voucher_pay_tos" ("organization_id", "branch_id");
-- create index "idx_voucher_pay_tos_deleted_at" to table: "voucher_pay_tos"
CREATE INDEX "idx_voucher_pay_tos_deleted_at" ON "voucher_pay_tos" ("deleted_at");

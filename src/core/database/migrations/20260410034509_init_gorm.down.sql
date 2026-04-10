-- reverse: create index "idx_voucher_pay_tos_deleted_at" to table: "voucher_pay_tos"
DROP INDEX "idx_voucher_pay_tos_deleted_at";
-- reverse: create index "idx_organization_branch_voucher_pay_to" to table: "voucher_pay_tos"
DROP INDEX "idx_organization_branch_voucher_pay_to";
-- reverse: create "voucher_pay_tos" table
DROP TABLE "voucher_pay_tos";
-- reverse: create index "idx_user_ratings_deleted_at" to table: "user_ratings"
DROP INDEX "idx_user_ratings_deleted_at";
-- reverse: create index "idx_branch_org_user_rating" to table: "user_ratings"
DROP INDEX "idx_branch_org_user_rating";
-- reverse: create "user_ratings" table
DROP TABLE "user_ratings";
-- reverse: create index "idx_transaction_tags_deleted_at" to table: "transaction_tags"
DROP INDEX "idx_transaction_tags_deleted_at";
-- reverse: create index "idx_organization_branch_transaction_tag" to table: "transaction_tags"
DROP INDEX "idx_organization_branch_transaction_tag";
-- reverse: create "transaction_tags" table
DROP TABLE "transaction_tags";
-- reverse: create index "idx_timesheets_deleted_at" to table: "timesheets"
DROP INDEX "idx_timesheets_deleted_at";
-- reverse: create index "idx_organization_branch_timesheet" to table: "timesheets"
DROP INDEX "idx_organization_branch_timesheet";
-- reverse: create "timesheets" table
DROP TABLE "timesheets";
-- reverse: create index "idx_time_deposit_computations_deleted_at" to table: "time_deposit_computations"
DROP INDEX "idx_time_deposit_computations_deleted_at";
-- reverse: create index "idx_organization_branch_time_deposit_computation" to table: "time_deposit_computations"
DROP INDEX "idx_organization_branch_time_deposit_computation";
-- reverse: create "time_deposit_computations" table
DROP TABLE "time_deposit_computations";
-- reverse: create index "idx_time_deposit_computation_pre_matures_deleted_at" to table: "time_deposit_computation_pre_matures"
DROP INDEX "idx_time_deposit_computation_pre_matures_deleted_at";
-- reverse: create index "idx_organization_branch_time_deposit_computation_pre_mature" to table: "time_deposit_computation_pre_matures"
DROP INDEX "idx_organization_branch_time_deposit_computation_pre_mature";
-- reverse: create "time_deposit_computation_pre_matures" table
DROP TABLE "time_deposit_computation_pre_matures";
-- reverse: create index "idx_time_deposit_types_deleted_at" to table: "time_deposit_types"
DROP INDEX "idx_time_deposit_types_deleted_at";
-- reverse: create index "idx_organization_branch_time_deposit_type" to table: "time_deposit_types"
DROP INDEX "idx_organization_branch_time_deposit_type";
-- reverse: create "time_deposit_types" table
DROP TABLE "time_deposit_types";
-- reverse: create index "idx_tag_templates_deleted_at" to table: "tag_templates"
DROP INDEX "idx_tag_templates_deleted_at";
-- reverse: create index "idx_organization_branch_tag_template" to table: "tag_templates"
DROP INDEX "idx_organization_branch_tag_template";
-- reverse: create "tag_templates" table
DROP TABLE "tag_templates";
-- reverse: create index "idx_revolving_fund_cash_counts_revolving_fund_id" to table: "revolving_fund_cash_counts"
DROP INDEX "idx_revolving_fund_cash_counts_revolving_fund_id";
-- reverse: create index "idx_revolving_fund_cash_counts_deleted_at" to table: "revolving_fund_cash_counts"
DROP INDEX "idx_revolving_fund_cash_counts_deleted_at";
-- reverse: create index "idx_org_branch_rf_cash_count" to table: "revolving_fund_cash_counts"
DROP INDEX "idx_org_branch_rf_cash_count";
-- reverse: create "revolving_fund_cash_counts" table
DROP TABLE "revolving_fund_cash_counts";
-- reverse: create index "idx_post_dated_checks_deleted_at" to table: "post_dated_checks"
DROP INDEX "idx_post_dated_checks_deleted_at";
-- reverse: create index "idx_organization_branch_post_dated_check" to table: "post_dated_checks"
DROP INDEX "idx_organization_branch_post_dated_check";
-- reverse: create "post_dated_checks" table
DROP TABLE "post_dated_checks";
-- reverse: create index "idx_permission_templates_deleted_at" to table: "permission_templates"
DROP INDEX "idx_permission_templates_deleted_at";
-- reverse: create index "idx_branch_org_permission_template" to table: "permission_templates"
DROP INDEX "idx_branch_org_permission_template";
-- reverse: create "permission_templates" table
DROP TABLE "permission_templates";
-- reverse: create index "idx_other_fund_tags_deleted_at" to table: "other_fund_tags"
DROP INDEX "idx_other_fund_tags_deleted_at";
-- reverse: create index "idx_organization_branch_other_fund_tag" to table: "other_fund_tags"
DROP INDEX "idx_organization_branch_other_fund_tag";
-- reverse: create "other_fund_tags" table
DROP TABLE "other_fund_tags";
-- reverse: create index "idx_other_fund_entries_deleted_at" to table: "other_fund_entries"
DROP INDEX "idx_other_fund_entries_deleted_at";
-- reverse: create index "idx_organization_branch_other_fund_entry" to table: "other_fund_entries"
DROP INDEX "idx_organization_branch_other_fund_entry";
-- reverse: create "other_fund_entries" table
DROP TABLE "other_fund_entries";
-- reverse: create index "idx_other_funds_deleted_at" to table: "other_funds"
DROP INDEX "idx_other_funds_deleted_at";
-- reverse: create index "idx_organization_branch_other_fund" to table: "other_funds"
DROP INDEX "idx_organization_branch_other_fund";
-- reverse: create "other_funds" table
DROP TABLE "other_funds";
-- reverse: create index "idx_organization_media_organization_id" to table: "organization_media"
DROP INDEX "idx_organization_media_organization_id";
-- reverse: create index "idx_organization_media_deleted_at" to table: "organization_media"
DROP INDEX "idx_organization_media_deleted_at";
-- reverse: create "organization_media" table
DROP TABLE "organization_media";
-- reverse: create index "idx_organization_daily_usages_deleted_at" to table: "organization_daily_usages"
DROP INDEX "idx_organization_daily_usages_deleted_at";
-- reverse: create "organization_daily_usages" table
DROP TABLE "organization_daily_usages";
-- reverse: create index "idx_organization_categories_deleted_at" to table: "organization_categories"
DROP INDEX "idx_organization_categories_deleted_at";
-- reverse: create "organization_categories" table
DROP TABLE "organization_categories";
-- reverse: create index "idx_categories_deleted_at" to table: "categories"
DROP INDEX "idx_categories_deleted_at";
-- reverse: create "categories" table
DROP TABLE "categories";
-- reverse: create index "idx_organization_branch_online_remittance" to table: "online_remittances"
DROP INDEX "idx_organization_branch_online_remittance";
-- reverse: create index "idx_online_remittances_deleted_at" to table: "online_remittances"
DROP INDEX "idx_online_remittances_deleted_at";
-- reverse: create "online_remittances" table
DROP TABLE "online_remittances";
-- reverse: create index "idx_notifications_deleted_at" to table: "notifications"
DROP INDEX "idx_notifications_deleted_at";
-- reverse: create "notifications" table
DROP TABLE "notifications";
-- reverse: create index "idx_organization_branch_mutual_fund_table" to table: "mutual_fund_tables"
DROP INDEX "idx_organization_branch_mutual_fund_table";
-- reverse: create index "idx_mutual_fund_tables_deleted_at" to table: "mutual_fund_tables"
DROP INDEX "idx_mutual_fund_tables_deleted_at";
-- reverse: create index "idx_mutual_fund_table" to table: "mutual_fund_tables"
DROP INDEX "idx_mutual_fund_table";
-- reverse: create "mutual_fund_tables" table
DROP TABLE "mutual_fund_tables";
-- reverse: create index "idx_organization_branch_mutual_fund_entry" to table: "mutual_fund_entries"
DROP INDEX "idx_organization_branch_mutual_fund_entry";
-- reverse: create index "idx_mutual_fund_entry_mutual_fund" to table: "mutual_fund_entries"
DROP INDEX "idx_mutual_fund_entry_mutual_fund";
-- reverse: create index "idx_mutual_fund_entry_member" to table: "mutual_fund_entries"
DROP INDEX "idx_mutual_fund_entry_member";
-- reverse: create index "idx_mutual_fund_entry_account" to table: "mutual_fund_entries"
DROP INDEX "idx_mutual_fund_entry_account";
-- reverse: create index "idx_mutual_fund_entries_deleted_at" to table: "mutual_fund_entries"
DROP INDEX "idx_mutual_fund_entries_deleted_at";
-- reverse: create "mutual_fund_entries" table
DROP TABLE "mutual_fund_entries";
-- reverse: create index "idx_organization_branch_mutual_fund_additional" to table: "mutual_fund_additional_members"
DROP INDEX "idx_organization_branch_mutual_fund_additional";
-- reverse: create index "idx_mutual_fund_additional_members_deleted_at" to table: "mutual_fund_additional_members"
DROP INDEX "idx_mutual_fund_additional_members_deleted_at";
-- reverse: create index "idx_mutual_fund_additional_members" to table: "mutual_fund_additional_members"
DROP INDEX "idx_mutual_fund_additional_members";
-- reverse: create index "idx_member_type_additional" to table: "mutual_fund_additional_members"
DROP INDEX "idx_member_type_additional";
-- reverse: create "mutual_fund_additional_members" table
DROP TABLE "mutual_fund_additional_members";
-- reverse: create index "idx_organization_branch_mutual_fund" to table: "mutual_funds"
DROP INDEX "idx_organization_branch_mutual_fund";
-- reverse: create index "idx_mutual_funds_deleted_at" to table: "mutual_funds"
DROP INDEX "idx_mutual_funds_deleted_at";
-- reverse: create "mutual_funds" table
DROP TABLE "mutual_funds";
-- reverse: create index "idx_organization_branch_member_verification" to table: "member_verifications"
DROP INDEX "idx_organization_branch_member_verification";
-- reverse: create index "idx_member_verifications_deleted_at" to table: "member_verifications"
DROP INDEX "idx_member_verifications_deleted_at";
-- reverse: create "member_verifications" table
DROP TABLE "member_verifications";
-- reverse: create index "idx_organization_branch_member_type_history" to table: "member_type_histories"
DROP INDEX "idx_organization_branch_member_type_history";
-- reverse: create index "idx_member_type_histories_deleted_at" to table: "member_type_histories"
DROP INDEX "idx_member_type_histories_deleted_at";
-- reverse: create "member_type_histories" table
DROP TABLE "member_type_histories";
-- reverse: create index "idx_organization_branch_member_relative_account" to table: "member_relative_accounts"
DROP INDEX "idx_organization_branch_member_relative_account";
-- reverse: create index "idx_member_relative_accounts_deleted_at" to table: "member_relative_accounts"
DROP INDEX "idx_member_relative_accounts_deleted_at";
-- reverse: create "member_relative_accounts" table
DROP TABLE "member_relative_accounts";
-- reverse: create index "idx_member_profile_media_deleted_at" to table: "member_profile_media"
DROP INDEX "idx_member_profile_media_deleted_at";
-- reverse: create "member_profile_media" table
DROP TABLE "member_profile_media";
-- reverse: create index "idx_organization_branch_member_profile_media" to table: "member_profile_archives"
DROP INDEX "idx_organization_branch_member_profile_media";
-- reverse: create index "idx_member_profile_archives_deleted_at" to table: "member_profile_archives"
DROP INDEX "idx_member_profile_archives_deleted_at";
-- reverse: create index "idx_member_profile_archives_category" to table: "member_profile_archives"
DROP INDEX "idx_member_profile_archives_category";
-- reverse: create "member_profile_archives" table
DROP TABLE "member_profile_archives";
-- reverse: create index "idx_organization_branch_member_other_information_entry" to table: "member_other_information_entries"
DROP INDEX "idx_organization_branch_member_other_information_entry";
-- reverse: create index "idx_member_other_information_entries_deleted_at" to table: "member_other_information_entries"
DROP INDEX "idx_member_other_information_entries_deleted_at";
-- reverse: create "member_other_information_entries" table
DROP TABLE "member_other_information_entries";
-- reverse: create index "idx_organization_branch_member_occupation_history" to table: "member_occupation_histories"
DROP INDEX "idx_organization_branch_member_occupation_history";
-- reverse: create index "idx_member_occupation_histories_deleted_at" to table: "member_occupation_histories"
DROP INDEX "idx_member_occupation_histories_deleted_at";
-- reverse: create "member_occupation_histories" table
DROP TABLE "member_occupation_histories";
-- reverse: create index "idx_organization_branch_member_mutual_fund_history" to table: "member_mutual_fund_histories"
DROP INDEX "idx_organization_branch_member_mutual_fund_history";
-- reverse: create index "idx_member_mutual_fund_histories_deleted_at" to table: "member_mutual_fund_histories"
DROP INDEX "idx_member_mutual_fund_histories_deleted_at";
-- reverse: create "member_mutual_fund_histories" table
DROP TABLE "member_mutual_fund_histories";
-- reverse: create index "idx_organization_branch_member_income" to table: "member_incomes"
DROP INDEX "idx_organization_branch_member_income";
-- reverse: create index "idx_member_incomes_deleted_at" to table: "member_incomes"
DROP INDEX "idx_member_incomes_deleted_at";
-- reverse: create "member_incomes" table
DROP TABLE "member_incomes";
-- reverse: create index "idx_organization_branch_member_group_history" to table: "member_group_histories"
DROP INDEX "idx_organization_branch_member_group_history";
-- reverse: create index "idx_member_group_histories_deleted_at" to table: "member_group_histories"
DROP INDEX "idx_member_group_histories_deleted_at";
-- reverse: create "member_group_histories" table
DROP TABLE "member_group_histories";
-- reverse: create index "idx_organization_branch_member_government_benefits" to table: "member_government_benefits"
DROP INDEX "idx_organization_branch_member_government_benefits";
-- reverse: create index "idx_member_government_benefits_deleted_at" to table: "member_government_benefits"
DROP INDEX "idx_member_government_benefits_deleted_at";
-- reverse: create "member_government_benefits" table
DROP TABLE "member_government_benefits";
-- reverse: create index "idx_organization_branch_member_gender_history" to table: "member_gender_histories"
DROP INDEX "idx_organization_branch_member_gender_history";
-- reverse: create index "idx_member_gender_histories_deleted_at" to table: "member_gender_histories"
DROP INDEX "idx_member_gender_histories_deleted_at";
-- reverse: create "member_gender_histories" table
DROP TABLE "member_gender_histories";
-- reverse: create index "idx_organization_branch_member_expense" to table: "member_expenses"
DROP INDEX "idx_organization_branch_member_expense";
-- reverse: create index "idx_member_expenses_deleted_at" to table: "member_expenses"
DROP INDEX "idx_member_expenses_deleted_at";
-- reverse: create "member_expenses" table
DROP TABLE "member_expenses";
-- reverse: create index "idx_organization_branch_member_educational_attainment" to table: "member_educational_attainments"
DROP INDEX "idx_organization_branch_member_educational_attainment";
-- reverse: create index "idx_member_educational_attainments_deleted_at" to table: "member_educational_attainments"
DROP INDEX "idx_member_educational_attainments_deleted_at";
-- reverse: create "member_educational_attainments" table
DROP TABLE "member_educational_attainments";
-- reverse: create index "idx_organization_branch_member_department_history" to table: "member_department_histories"
DROP INDEX "idx_organization_branch_member_department_history";
-- reverse: create index "idx_member_department_histories_deleted_at" to table: "member_department_histories"
DROP INDEX "idx_member_department_histories_deleted_at";
-- reverse: create "member_department_histories" table
DROP TABLE "member_department_histories";
-- reverse: create index "idx_organization_branch_member_deduction_entry" to table: "member_deduction_entries"
DROP INDEX "idx_organization_branch_member_deduction_entry";
-- reverse: create index "idx_member_deduction_entries_deleted_at" to table: "member_deduction_entries"
DROP INDEX "idx_member_deduction_entries_deleted_at";
-- reverse: create "member_deduction_entries" table
DROP TABLE "member_deduction_entries";
-- reverse: create index "idx_organization_branch_member_damayan_extension_entry" to table: "member_damayan_extension_entries"
DROP INDEX "idx_organization_branch_member_damayan_extension_entry";
-- reverse: create index "idx_member_damayan_extension_entries_deleted_at" to table: "member_damayan_extension_entries"
DROP INDEX "idx_member_damayan_extension_entries_deleted_at";
-- reverse: create "member_damayan_extension_entries" table
DROP TABLE "member_damayan_extension_entries";
-- reverse: create index "idx_organization_branch_member_contact_reference" to table: "member_contact_references"
DROP INDEX "idx_organization_branch_member_contact_reference";
-- reverse: create index "idx_member_contact_references_deleted_at" to table: "member_contact_references"
DROP INDEX "idx_member_contact_references_deleted_at";
-- reverse: create "member_contact_references" table
DROP TABLE "member_contact_references";
-- reverse: create index "idx_organization_branch_member_close_remark" to table: "member_close_remarks"
DROP INDEX "idx_organization_branch_member_close_remark";
-- reverse: create index "idx_member_close_remarks_deleted_at" to table: "member_close_remarks"
DROP INDEX "idx_member_close_remarks_deleted_at";
-- reverse: create "member_close_remarks" table
DROP TABLE "member_close_remarks";
-- reverse: create index "idx_organization_branch_member_classification_history" to table: "member_classification_histories"
DROP INDEX "idx_organization_branch_member_classification_history";
-- reverse: create index "idx_member_classification_histories_deleted_at" to table: "member_classification_histories"
DROP INDEX "idx_member_classification_histories_deleted_at";
-- reverse: create "member_classification_histories" table
DROP TABLE "member_classification_histories";
-- reverse: create index "idx_organization_branch_member_center_history" to table: "member_center_histories"
DROP INDEX "idx_organization_branch_member_center_history";
-- reverse: create index "idx_member_center_histories_deleted_at" to table: "member_center_histories"
DROP INDEX "idx_member_center_histories_deleted_at";
-- reverse: create "member_center_histories" table
DROP TABLE "member_center_histories";
-- reverse: create index "idx_organization_branch_member_card" to table: "member_bank_cards"
DROP INDEX "idx_organization_branch_member_card";
-- reverse: create index "idx_member_bank_cards_deleted_at" to table: "member_bank_cards"
DROP INDEX "idx_member_bank_cards_deleted_at";
-- reverse: create "member_bank_cards" table
DROP TABLE "member_bank_cards";
-- reverse: create index "idx_organization_branch_member_asset" to table: "member_assets"
DROP INDEX "idx_organization_branch_member_asset";
-- reverse: create index "idx_member_assets_deleted_at" to table: "member_assets"
DROP INDEX "idx_member_assets_deleted_at";
-- reverse: create "member_assets" table
DROP TABLE "member_assets";
-- reverse: create index "idx_organization_branch_member_address" to table: "member_addresses"
DROP INDEX "idx_organization_branch_member_address";
-- reverse: create index "idx_member_addresses_deleted_at" to table: "member_addresses"
DROP INDEX "idx_member_addresses_deleted_at";
-- reverse: create "member_addresses" table
DROP TABLE "member_addresses";
-- reverse: create index "idx_organization_branch_loan_transaction_entry" to table: "loan_transaction_entries"
DROP INDEX "idx_organization_branch_loan_transaction_entry";
-- reverse: create index "idx_loan_transaction_entry_loan_transaction" to table: "loan_transaction_entries"
DROP INDEX "idx_loan_transaction_entry_loan_transaction";
-- reverse: create index "idx_loan_transaction_entries_member_profile_id" to table: "loan_transaction_entries"
DROP INDEX "idx_loan_transaction_entries_member_profile_id";
-- reverse: create index "idx_loan_transaction_entries_member_loan_transaction_id" to table: "loan_transaction_entries"
DROP INDEX "idx_loan_transaction_entries_member_loan_transaction_id";
-- reverse: create index "idx_loan_transaction_entries_deleted_at" to table: "loan_transaction_entries"
DROP INDEX "idx_loan_transaction_entries_deleted_at";
-- reverse: create "loan_transaction_entries" table
DROP TABLE "loan_transaction_entries";
-- reverse: create index "idx_organization_branch_loan_terms_and_condition_suggested_paym" to table: "loan_terms_and_condition_suggested_payments"
DROP INDEX "idx_organization_branch_loan_terms_and_condition_suggested_paym";
-- reverse: create index "idx_loan_terms_and_condition_suggested_payments_deleted_at" to table: "loan_terms_and_condition_suggested_payments"
DROP INDEX "idx_loan_terms_and_condition_suggested_payments_deleted_at";
-- reverse: create "loan_terms_and_condition_suggested_payments" table
DROP TABLE "loan_terms_and_condition_suggested_payments";
-- reverse: create index "idx_organization_branch_loan_terms_and_condition_amount_receipt" to table: "loan_terms_and_condition_amount_receipts"
DROP INDEX "idx_organization_branch_loan_terms_and_condition_amount_receipt";
-- reverse: create index "idx_loan_terms_and_condition_amount_receipts_deleted_at" to table: "loan_terms_and_condition_amount_receipts"
DROP INDEX "idx_loan_terms_and_condition_amount_receipts_deleted_at";
-- reverse: create "loan_terms_and_condition_amount_receipts" table
DROP TABLE "loan_terms_and_condition_amount_receipts";
-- reverse: create index "idx_organization_branch_loan_tag" to table: "loan_tags"
DROP INDEX "idx_organization_branch_loan_tag";
-- reverse: create index "idx_loan_tags_deleted_at" to table: "loan_tags"
DROP INDEX "idx_loan_tags_deleted_at";
-- reverse: create "loan_tags" table
DROP TABLE "loan_tags";
-- reverse: create index "idx_organization_branch_loan_guaranteed_fund" to table: "loan_guaranteed_funds"
DROP INDEX "idx_organization_branch_loan_guaranteed_fund";
-- reverse: create index "idx_loan_guaranteed_funds_deleted_at" to table: "loan_guaranteed_funds"
DROP INDEX "idx_loan_guaranteed_funds_deleted_at";
-- reverse: create "loan_guaranteed_funds" table
DROP TABLE "loan_guaranteed_funds";
-- reverse: create index "idx_organization_branch_loan_guaranteed_fund_per_month" to table: "loan_guaranteed_fund_per_months"
DROP INDEX "idx_organization_branch_loan_guaranteed_fund_per_month";
-- reverse: create index "idx_loan_guaranteed_fund_per_months_deleted_at" to table: "loan_guaranteed_fund_per_months"
DROP INDEX "idx_loan_guaranteed_fund_per_months_deleted_at";
-- reverse: create "loan_guaranteed_fund_per_months" table
DROP TABLE "loan_guaranteed_fund_per_months";
-- reverse: create index "idx_organization_branch_loan_comaker_member" to table: "loan_comaker_members"
DROP INDEX "idx_organization_branch_loan_comaker_member";
-- reverse: create index "idx_loan_comaker_members_deleted_at" to table: "loan_comaker_members"
DROP INDEX "idx_loan_comaker_members_deleted_at";
-- reverse: create "loan_comaker_members" table
DROP TABLE "loan_comaker_members";
-- reverse: create index "idx_organization_branch_loan_clearance_analysis_institution" to table: "loan_clearance_analysis_institutions"
DROP INDEX "idx_organization_branch_loan_clearance_analysis_institution";
-- reverse: create index "idx_loan_clearance_analysis_institutions_deleted_at" to table: "loan_clearance_analysis_institutions"
DROP INDEX "idx_loan_clearance_analysis_institutions_deleted_at";
-- reverse: create "loan_clearance_analysis_institutions" table
DROP TABLE "loan_clearance_analysis_institutions";
-- reverse: create index "idx_organization_branch_loan_clearance_analysis" to table: "loan_clearance_analyses"
DROP INDEX "idx_organization_branch_loan_clearance_analysis";
-- reverse: create index "idx_loan_clearance_analyses_deleted_at" to table: "loan_clearance_analyses"
DROP INDEX "idx_loan_clearance_analyses_deleted_at";
-- reverse: create "loan_clearance_analyses" table
DROP TABLE "loan_clearance_analyses";
-- reverse: create index "idx_organization_branch_loan_account" to table: "loan_accounts"
DROP INDEX "idx_organization_branch_loan_account";
-- reverse: create index "idx_loan_accounts_deleted_at" to table: "loan_accounts"
DROP INDEX "idx_loan_accounts_deleted_at";
-- reverse: create index "idx_loan_account_loan_transaction" to table: "loan_accounts"
DROP INDEX "idx_loan_account_loan_transaction";
-- reverse: create "loan_accounts" table
DROP TABLE "loan_accounts";
-- reverse: create index "idx_organization_branch_journal_voucher_tag" to table: "journal_voucher_tags"
DROP INDEX "idx_organization_branch_journal_voucher_tag";
-- reverse: create index "idx_journal_voucher_tags_deleted_at" to table: "journal_voucher_tags"
DROP INDEX "idx_journal_voucher_tags_deleted_at";
-- reverse: create "journal_voucher_tags" table
DROP TABLE "journal_voucher_tags";
-- reverse: create index "idx_organization_branch_journal_voucher_entry" to table: "journal_voucher_entries"
DROP INDEX "idx_organization_branch_journal_voucher_entry";
-- reverse: create index "idx_journal_voucher_entries_deleted_at" to table: "journal_voucher_entries"
DROP INDEX "idx_journal_voucher_entries_deleted_at";
-- reverse: create "journal_voucher_entries" table
DROP TABLE "journal_voucher_entries";
-- reverse: create index "idx_organization_branch_journal_voucher" to table: "journal_vouchers"
DROP INDEX "idx_organization_branch_journal_voucher";
-- reverse: create index "idx_journal_vouchers_deleted_at" to table: "journal_vouchers"
DROP INDEX "idx_journal_vouchers_deleted_at";
-- reverse: create "journal_vouchers" table
DROP TABLE "journal_vouchers";
-- reverse: create index "idx_invitation_codes_deleted_at" to table: "invitation_codes"
DROP INDEX "idx_invitation_codes_deleted_at";
-- reverse: create index "idx_branch_org_invitation_code" to table: "invitation_codes"
DROP INDEX "idx_branch_org_invitation_code";
-- reverse: create "invitation_codes" table
DROP TABLE "invitation_codes";
-- reverse: create index "idx_organization_branch_inventory_tag" to table: "inventory_tags"
DROP INDEX "idx_organization_branch_inventory_tag";
-- reverse: create index "idx_inventory_tags_deleted_at" to table: "inventory_tags"
DROP INDEX "idx_inventory_tags_deleted_at";
-- reverse: create "inventory_tags" table
DROP TABLE "inventory_tags";
-- reverse: create index "idx_org_branch_item_entry" to table: "inventory_item_entries"
DROP INDEX "idx_org_branch_item_entry";
-- reverse: create index "idx_inventory_item_entries_deleted_at" to table: "inventory_item_entries"
DROP INDEX "idx_inventory_item_entries_deleted_at";
-- reverse: create "inventory_item_entries" table
DROP TABLE "inventory_item_entries";
-- reverse: create index "idx_org_branch_item" to table: "inventory_items"
DROP INDEX "idx_org_branch_item";
-- reverse: create index "idx_inventory_items_deleted_at" to table: "inventory_items"
DROP INDEX "idx_inventory_items_deleted_at";
-- reverse: create "inventory_items" table
DROP TABLE "inventory_items";
-- reverse: create index "idx_organization_branch_warehouse" to table: "inventory_warehouses"
DROP INDEX "idx_organization_branch_warehouse";
-- reverse: create index "idx_inventory_warehouses_deleted_at" to table: "inventory_warehouses"
DROP INDEX "idx_inventory_warehouses_deleted_at";
-- reverse: create "inventory_warehouses" table
DROP TABLE "inventory_warehouses";
-- reverse: create index "idx_organization_branch_supplier" to table: "inventory_suppliers"
DROP INDEX "idx_organization_branch_supplier";
-- reverse: create index "idx_inventory_suppliers_deleted_at" to table: "inventory_suppliers"
DROP INDEX "idx_inventory_suppliers_deleted_at";
-- reverse: create "inventory_suppliers" table
DROP TABLE "inventory_suppliers";
-- reverse: create index "idx_organization_branch_hazard" to table: "inventory_hazards"
DROP INDEX "idx_organization_branch_hazard";
-- reverse: create index "idx_inventory_hazards_deleted_at" to table: "inventory_hazards"
DROP INDEX "idx_inventory_hazards_deleted_at";
-- reverse: create "inventory_hazards" table
DROP TABLE "inventory_hazards";
-- reverse: create index "idx_organization_branch_category" to table: "inventory_categories"
DROP INDEX "idx_organization_branch_category";
-- reverse: create index "idx_inventory_categories_deleted_at" to table: "inventory_categories"
DROP INDEX "idx_inventory_categories_deleted_at";
-- reverse: create "inventory_categories" table
DROP TABLE "inventory_categories";
-- reverse: create index "idx_organization_branch_brand" to table: "inventory_brands"
DROP INDEX "idx_organization_branch_brand";
-- reverse: create index "idx_inventory_brands_deleted_at" to table: "inventory_brands"
DROP INDEX "idx_inventory_brands_deleted_at";
-- reverse: create "inventory_brands" table
DROP TABLE "inventory_brands";
-- reverse: create index "idx_organization_branch_interest_rate_percentage" to table: "interest_rate_percentages"
DROP INDEX "idx_organization_branch_interest_rate_percentage";
-- reverse: create index "idx_interest_rate_percentages_deleted_at" to table: "interest_rate_percentages"
DROP INDEX "idx_interest_rate_percentages_deleted_at";
-- reverse: create "interest_rate_percentages" table
DROP TABLE "interest_rate_percentages";
-- reverse: create index "idx_organization_branch_interest_rate_by_year" to table: "interest_rate_by_years"
DROP INDEX "idx_organization_branch_interest_rate_by_year";
-- reverse: create index "idx_interest_rate_by_years_deleted_at" to table: "interest_rate_by_years"
DROP INDEX "idx_interest_rate_by_years_deleted_at";
-- reverse: create index "idx_browse_reference_year_range" to table: "interest_rate_by_years"
DROP INDEX "idx_browse_reference_year_range";
-- reverse: create "interest_rate_by_years" table
DROP TABLE "interest_rate_by_years";
-- reverse: create index "idx_organization_branch_interest_rate_by_term" to table: "interest_rate_by_terms"
DROP INDEX "idx_organization_branch_interest_rate_by_term";
-- reverse: create index "idx_interest_rate_by_terms_deleted_at" to table: "interest_rate_by_terms"
DROP INDEX "idx_interest_rate_by_terms_deleted_at";
-- reverse: create "interest_rate_by_terms" table
DROP TABLE "interest_rate_by_terms";
-- reverse: create index "idx_organization_branch_member_classification_interest_rate" to table: "member_classification_interest_rates"
DROP INDEX "idx_organization_branch_member_classification_interest_rate";
-- reverse: create index "idx_member_classification_interest_rates_deleted_at" to table: "member_classification_interest_rates"
DROP INDEX "idx_member_classification_interest_rates_deleted_at";
-- reverse: create "member_classification_interest_rates" table
DROP TABLE "member_classification_interest_rates";
-- reverse: create index "idx_organization_branch_interest_rate_scheme" to table: "interest_rate_schemes"
DROP INDEX "idx_organization_branch_interest_rate_scheme";
-- reverse: create index "idx_interest_rate_schemes_deleted_at" to table: "interest_rate_schemes"
DROP INDEX "idx_interest_rate_schemes_deleted_at";
-- reverse: create "interest_rate_schemes" table
DROP TABLE "interest_rate_schemes";
-- reverse: create index "idx_organization_branch_interest_rate_by_date" to table: "interest_rate_by_dates"
DROP INDEX "idx_organization_branch_interest_rate_by_date";
-- reverse: create index "idx_interest_rate_by_dates_deleted_at" to table: "interest_rate_by_dates"
DROP INDEX "idx_interest_rate_by_dates_deleted_at";
-- reverse: create index "idx_browse_reference_date_range" to table: "interest_rate_by_dates"
DROP INDEX "idx_browse_reference_date_range";
-- reverse: create "interest_rate_by_dates" table
DROP TABLE "interest_rate_by_dates";
-- reverse: create index "idx_organization_branch_interest_rate_by_amount" to table: "interest_rate_by_amounts"
DROP INDEX "idx_organization_branch_interest_rate_by_amount";
-- reverse: create index "idx_interest_rate_by_amounts_deleted_at" to table: "interest_rate_by_amounts"
DROP INDEX "idx_interest_rate_by_amounts_deleted_at";
-- reverse: create index "idx_browse_reference_amount_range" to table: "interest_rate_by_amounts"
DROP INDEX "idx_browse_reference_amount_range";
-- reverse: create "interest_rate_by_amounts" table
DROP TABLE "interest_rate_by_amounts";
-- reverse: create index "idx_organization_branch_interest_maturity" to table: "interest_maturities"
DROP INDEX "idx_organization_branch_interest_maturity";
-- reverse: create index "idx_interest_maturities_deleted_at" to table: "interest_maturities"
DROP INDEX "idx_interest_maturities_deleted_at";
-- reverse: create "interest_maturities" table
DROP TABLE "interest_maturities";
-- reverse: create index "idx_organization_branch_include_negative_account" to table: "include_negative_accounts"
DROP INDEX "idx_organization_branch_include_negative_account";
-- reverse: create index "idx_include_negative_accounts_deleted_at" to table: "include_negative_accounts"
DROP INDEX "idx_include_negative_accounts_deleted_at";
-- reverse: create "include_negative_accounts" table
DROP TABLE "include_negative_accounts";
-- reverse: create index "idx_organization_branch_holidays" to table: "holidays"
DROP INDEX "idx_organization_branch_holidays";
-- reverse: create index "idx_holidays_deleted_at" to table: "holidays"
DROP INDEX "idx_holidays_deleted_at";
-- reverse: create "holidays" table
DROP TABLE "holidays";
-- reverse: create index "idx_organization_branch_grocery_computation_sheet_monthly" to table: "grocery_computation_sheet_monthlies"
DROP INDEX "idx_organization_branch_grocery_computation_sheet_monthly";
-- reverse: create index "idx_grocery_computation_sheet_monthlies_deleted_at" to table: "grocery_computation_sheet_monthlies"
DROP INDEX "idx_grocery_computation_sheet_monthlies_deleted_at";
-- reverse: create "grocery_computation_sheet_monthlies" table
DROP TABLE "grocery_computation_sheet_monthlies";
-- reverse: create index "idx_organization_branch_grocery_computation_sheet" to table: "grocery_computation_sheets"
DROP INDEX "idx_organization_branch_grocery_computation_sheet";
-- reverse: create index "idx_grocery_computation_sheets_deleted_at" to table: "grocery_computation_sheets"
DROP INDEX "idx_grocery_computation_sheets_deleted_at";
-- reverse: create "grocery_computation_sheets" table
DROP TABLE "grocery_computation_sheets";
-- reverse: create index "idx_organization_branch_generate_savings_interest_entry" to table: "generated_savings_interest_entries"
DROP INDEX "idx_organization_branch_generate_savings_interest_entry";
-- reverse: create index "idx_generated_savings_interest_entry" to table: "generated_savings_interest_entries"
DROP INDEX "idx_generated_savings_interest_entry";
-- reverse: create index "idx_generated_savings_interest_entries_deleted_at" to table: "generated_savings_interest_entries"
DROP INDEX "idx_generated_savings_interest_entries_deleted_at";
-- reverse: create index "idx_account_member_profile_entry" to table: "generated_savings_interest_entries"
DROP INDEX "idx_account_member_profile_entry";
-- reverse: create "generated_savings_interest_entries" table
DROP TABLE "generated_savings_interest_entries";
-- reverse: create index "idx_organization_branch_generated_savings_interest" to table: "generated_savings_interests"
DROP INDEX "idx_organization_branch_generated_savings_interest";
-- reverse: create index "idx_generated_savings_interests_deleted_at" to table: "generated_savings_interests"
DROP INDEX "idx_generated_savings_interests_deleted_at";
-- reverse: create "generated_savings_interests" table
DROP TABLE "generated_savings_interests";
-- reverse: create index "idx_user_organization_generated_reports_download" to table: "generated_reports_download_users"
DROP INDEX "idx_user_organization_generated_reports_download";
-- reverse: create index "idx_user_generated_reports_download" to table: "generated_reports_download_users"
DROP INDEX "idx_user_generated_reports_download";
-- reverse: create index "idx_organization_branch_generated_reports_download_users" to table: "generated_reports_download_users"
DROP INDEX "idx_organization_branch_generated_reports_download_users";
-- reverse: create index "idx_generated_reports_download_users_deleted_at" to table: "generated_reports_download_users"
DROP INDEX "idx_generated_reports_download_users_deleted_at";
-- reverse: create index "idx_generated_report_download_users" to table: "generated_reports_download_users"
DROP INDEX "idx_generated_report_download_users";
-- reverse: create "generated_reports_download_users" table
DROP TABLE "generated_reports_download_users";
-- reverse: create index "idx_user_organizations_settings_payment_type_default_value_id" to table: "user_organizations"
DROP INDEX "idx_user_organizations_settings_payment_type_default_value_id";
-- reverse: create index "idx_user_organizations_settings_accounting_withdraw_def5e5c1fbd" to table: "user_organizations"
DROP INDEX "idx_user_organizations_settings_accounting_withdraw_def5e5c1fbd";
-- reverse: create index "idx_user_organizations_settings_accounting_payment_defacde68a25" to table: "user_organizations"
DROP INDEX "idx_user_organizations_settings_accounting_payment_defacde68a25";
-- reverse: create index "idx_user_organizations_settings_accounting_deposit_defae220a44c" to table: "user_organizations"
DROP INDEX "idx_user_organizations_settings_accounting_deposit_defae220a44c";
-- reverse: create index "idx_user_organizations_deleted_at" to table: "user_organizations"
DROP INDEX "idx_user_organizations_deleted_at";
-- reverse: create index "idx_user_org_branch" to table: "user_organizations"
DROP INDEX "idx_user_org_branch";
-- reverse: create "user_organizations" table
DROP TABLE "user_organizations";
-- reverse: create index "idx_generated_reports_deleted_at" to table: "generated_reports"
DROP INDEX "idx_generated_reports_deleted_at";
-- reverse: create index "idx_branch_org_generated_report" to table: "generated_reports"
DROP INDEX "idx_branch_org_generated_report";
-- reverse: create "generated_reports" table
DROP TABLE "generated_reports";
-- reverse: create index "idx_organization_branch_general_ledger_tag" to table: "general_accounting_ledger_tags"
DROP INDEX "idx_organization_branch_general_ledger_tag";
-- reverse: create index "idx_general_accounting_ledger_tags_deleted_at" to table: "general_accounting_ledger_tags"
DROP INDEX "idx_general_accounting_ledger_tags_deleted_at";
-- reverse: create "general_accounting_ledger_tags" table
DROP TABLE "general_accounting_ledger_tags";
-- reverse: create index "idx_transaction_batch_entry" to table: "general_ledgers"
DROP INDEX "idx_transaction_batch_entry";
-- reverse: create index "idx_organization_branch_general_ledger" to table: "general_ledgers"
DROP INDEX "idx_organization_branch_general_ledger";
-- reverse: create index "idx_org_branch_account_member" to table: "general_ledgers"
DROP INDEX "idx_org_branch_account_member";
-- reverse: create index "idx_ledger_pagination" to table: "general_ledgers"
DROP INDEX "idx_ledger_pagination";
-- reverse: create index "idx_general_ledgers_deleted_at" to table: "general_ledgers"
DROP INDEX "idx_general_ledgers_deleted_at";
-- reverse: create index "idx_general_ledgers_created_at" to table: "general_ledgers"
DROP INDEX "idx_general_ledgers_created_at";
-- reverse: create "general_ledgers" table
DROP TABLE "general_ledgers";
-- reverse: create index "idx_transactions_deleted_at" to table: "transactions"
DROP INDEX "idx_transactions_deleted_at";
-- reverse: create index "idx_organization_branch_transaction" to table: "transactions"
DROP INDEX "idx_organization_branch_transaction";
-- reverse: create "transactions" table
DROP TABLE "transactions";
-- reverse: create index "idx_organization_branch_member_join_account" to table: "member_joint_accounts"
DROP INDEX "idx_organization_branch_member_join_account";
-- reverse: create index "idx_member_joint_accounts_deleted_at" to table: "member_joint_accounts"
DROP INDEX "idx_member_joint_accounts_deleted_at";
-- reverse: create "member_joint_accounts" table
DROP TABLE "member_joint_accounts";
-- reverse: create index "idx_organization_branch_general_account_grouping_net_surplus_po" to table: "general_account_grouping_net_surplus_positives"
DROP INDEX "idx_organization_branch_general_account_grouping_net_surplus_po";
-- reverse: create index "idx_general_account_grouping_net_surplus_positives_deleted_at" to table: "general_account_grouping_net_surplus_positives"
DROP INDEX "idx_general_account_grouping_net_surplus_positives_deleted_at";
-- reverse: create "general_account_grouping_net_surplus_positives" table
DROP TABLE "general_account_grouping_net_surplus_positives";
-- reverse: create index "idx_organization_branch_general_account_grouping_net_surplus_ne" to table: "general_account_grouping_net_surplus_negatives"
DROP INDEX "idx_organization_branch_general_account_grouping_net_surplus_ne";
-- reverse: create index "idx_general_account_grouping_net_surplus_negatives_deleted_at" to table: "general_account_grouping_net_surplus_negatives"
DROP INDEX "idx_general_account_grouping_net_surplus_negatives_deleted_at";
-- reverse: create "general_account_grouping_net_surplus_negatives" table
DROP TABLE "general_account_grouping_net_surplus_negatives";
-- reverse: create index "idx_organization_branch_funds" to table: "funds"
DROP INDEX "idx_organization_branch_funds";
-- reverse: create index "idx_funds_deleted_at" to table: "funds"
DROP INDEX "idx_funds_deleted_at";
-- reverse: create "funds" table
DROP TABLE "funds";
-- reverse: create index "idx_footsteps_deleted_at" to table: "footsteps"
DROP INDEX "idx_footsteps_deleted_at";
-- reverse: create index "idx_branch_org_footstep" to table: "footsteps"
DROP INDEX "idx_branch_org_footstep";
-- reverse: create "footsteps" table
DROP TABLE "footsteps";
-- reverse: create index "idx_organization_branch_fines_maturity" to table: "fines_maturities"
DROP INDEX "idx_organization_branch_fines_maturity";
-- reverse: create index "idx_fines_maturities_deleted_at" to table: "fines_maturities"
DROP INDEX "idx_fines_maturities_deleted_at";
-- reverse: create "fines_maturities" table
DROP TABLE "fines_maturities";
-- reverse: create index "idx_feedbacks_deleted_at" to table: "feedbacks"
DROP INDEX "idx_feedbacks_deleted_at";
-- reverse: create "feedbacks" table
DROP TABLE "feedbacks";
-- reverse: create index "idx_organization_branch_feed_media" to table: "feed_media"
DROP INDEX "idx_organization_branch_feed_media";
-- reverse: create index "idx_feed_media_deleted_at" to table: "feed_media"
DROP INDEX "idx_feed_media_deleted_at";
-- reverse: create index "idx_feed_media" to table: "feed_media"
DROP INDEX "idx_feed_media";
-- reverse: create "feed_media" table
DROP TABLE "feed_media";
-- reverse: create index "idx_organization_branch_feed_like" to table: "feed_likes"
DROP INDEX "idx_organization_branch_feed_like";
-- reverse: create index "idx_feed_likes_deleted_at" to table: "feed_likes"
DROP INDEX "idx_feed_likes_deleted_at";
-- reverse: create index "idx_feed_like_unique" to table: "feed_likes"
DROP INDEX "idx_feed_like_unique";
-- reverse: create "feed_likes" table
DROP TABLE "feed_likes";
-- reverse: create index "idx_organization_branch_feed_comment" to table: "feed_comments"
DROP INDEX "idx_organization_branch_feed_comment";
-- reverse: create index "idx_feed_comments_deleted_at" to table: "feed_comments"
DROP INDEX "idx_feed_comments_deleted_at";
-- reverse: create index "idx_feed_comment" to table: "feed_comments"
DROP INDEX "idx_feed_comment";
-- reverse: create "feed_comments" table
DROP TABLE "feed_comments";
-- reverse: create index "idx_organization_branch_feed" to table: "feeds"
DROP INDEX "idx_organization_branch_feed";
-- reverse: create index "idx_feeds_deleted_at" to table: "feeds"
DROP INDEX "idx_feeds_deleted_at";
-- reverse: create "feeds" table
DROP TABLE "feeds";
-- reverse: create index "idx_organization_branch_disbursement_transaction" to table: "disbursement_transactions"
DROP INDEX "idx_organization_branch_disbursement_transaction";
-- reverse: create index "idx_disbursement_transactions_deleted_at" to table: "disbursement_transactions"
DROP INDEX "idx_disbursement_transactions_deleted_at";
-- reverse: create "disbursement_transactions" table
DROP TABLE "disbursement_transactions";
-- reverse: create index "idx_organization_branch_disbursement" to table: "disbursements"
DROP INDEX "idx_organization_branch_disbursement";
-- reverse: create index "idx_disbursements_deleted_at" to table: "disbursements"
DROP INDEX "idx_disbursements_deleted_at";
-- reverse: create "disbursements" table
DROP TABLE "disbursements";
-- reverse: create index "idx_organization_branch_company" to table: "companies"
DROP INDEX "idx_organization_branch_company";
-- reverse: create index "idx_companies_deleted_at" to table: "companies"
DROP INDEX "idx_companies_deleted_at";
-- reverse: create "companies" table
DROP TABLE "companies";
-- reverse: create index "idx_organization_branch_comaker_member_profile" to table: "comaker_member_profiles"
DROP INDEX "idx_organization_branch_comaker_member_profile";
-- reverse: create index "idx_loan_transaction_comaker" to table: "comaker_member_profiles"
DROP INDEX "idx_loan_transaction_comaker";
-- reverse: create index "idx_comaker_member_profiles_deleted_at" to table: "comaker_member_profiles"
DROP INDEX "idx_comaker_member_profiles_deleted_at";
-- reverse: create "comaker_member_profiles" table
DROP TABLE "comaker_member_profiles";
-- reverse: create index "idx_organization_branch_comaker_collateral" to table: "comaker_collaterals"
DROP INDEX "idx_organization_branch_comaker_collateral";
-- reverse: create index "idx_loan_transaction_comaker_collateral" to table: "comaker_collaterals"
DROP INDEX "idx_loan_transaction_comaker_collateral";
-- reverse: create index "idx_comaker_collaterals_deleted_at" to table: "comaker_collaterals"
DROP INDEX "idx_comaker_collaterals_deleted_at";
-- reverse: create "comaker_collaterals" table
DROP TABLE "comaker_collaterals";
-- reverse: create index "idx_organization_branch_collectors_member_account_entry" to table: "collectors_member_account_entries"
DROP INDEX "idx_organization_branch_collectors_member_account_entry";
-- reverse: create index "idx_collectors_member_account_entries_deleted_at" to table: "collectors_member_account_entries"
DROP INDEX "idx_collectors_member_account_entries_deleted_at";
-- reverse: create "collectors_member_account_entries" table
DROP TABLE "collectors_member_account_entries";
-- reverse: create index "idx_organization_branch_collateral" to table: "collaterals"
DROP INDEX "idx_organization_branch_collateral";
-- reverse: create index "idx_collaterals_deleted_at" to table: "collaterals"
DROP INDEX "idx_collaterals_deleted_at";
-- reverse: create "collaterals" table
DROP TABLE "collaterals";
-- reverse: create index "idx_org_branch_check" to table: "check_warehousings"
DROP INDEX "idx_org_branch_check";
-- reverse: create index "idx_check_warehousings_reference_number" to table: "check_warehousings"
DROP INDEX "idx_check_warehousings_reference_number";
-- reverse: create index "idx_check_warehousings_member_profile_id" to table: "check_warehousings"
DROP INDEX "idx_check_warehousings_member_profile_id";
-- reverse: create index "idx_check_warehousings_deleted_at" to table: "check_warehousings"
DROP INDEX "idx_check_warehousings_deleted_at";
-- reverse: create index "idx_check_warehousings_check_number" to table: "check_warehousings"
DROP INDEX "idx_check_warehousings_check_number";
-- reverse: create index "idx_check_warehousings_bank_id" to table: "check_warehousings"
DROP INDEX "idx_check_warehousings_bank_id";
-- reverse: create "check_warehousings" table
DROP TABLE "check_warehousings";
-- reverse: create index "idx_organization_branch_check_remittance" to table: "check_remittances"
DROP INDEX "idx_organization_branch_check_remittance";
-- reverse: create index "idx_check_remittances_deleted_at" to table: "check_remittances"
DROP INDEX "idx_check_remittances_deleted_at";
-- reverse: create "check_remittances" table
DROP TABLE "check_remittances";
-- reverse: create index "idx_organization_branch_charges_rate_scheme_mode_of_payment" to table: "charges_rate_scheme_mode_of_payments"
DROP INDEX "idx_organization_branch_charges_rate_scheme_mode_of_payment";
-- reverse: create index "idx_charges_rate_scheme_mode_of_payments_deleted_at" to table: "charges_rate_scheme_mode_of_payments"
DROP INDEX "idx_charges_rate_scheme_mode_of_payments_deleted_at";
-- reverse: create "charges_rate_scheme_mode_of_payments" table
DROP TABLE "charges_rate_scheme_mode_of_payments";
-- reverse: create index "idx_organization_branch_charges_rate_scheme_account" to table: "charges_rate_scheme_accounts"
DROP INDEX "idx_organization_branch_charges_rate_scheme_account";
-- reverse: create index "idx_charges_rate_scheme_accounts_deleted_at" to table: "charges_rate_scheme_accounts"
DROP INDEX "idx_charges_rate_scheme_accounts_deleted_at";
-- reverse: create "charges_rate_scheme_accounts" table
DROP TABLE "charges_rate_scheme_accounts";
-- reverse: create index "idx_organization_branch_charges_rate_by_term" to table: "charges_rate_by_terms"
DROP INDEX "idx_organization_branch_charges_rate_by_term";
-- reverse: create index "idx_charges_rate_by_terms_deleted_at" to table: "charges_rate_by_terms"
DROP INDEX "idx_charges_rate_by_terms_deleted_at";
-- reverse: create "charges_rate_by_terms" table
DROP TABLE "charges_rate_by_terms";
-- reverse: create index "idx_organization_branch_charges_rate_by_range_or_minimum_amount" to table: "charges_rate_by_range_or_minimum_amounts"
DROP INDEX "idx_organization_branch_charges_rate_by_range_or_minimum_amount";
-- reverse: create index "idx_charges_rate_by_range_or_minimum_amounts_deleted_at" to table: "charges_rate_by_range_or_minimum_amounts"
DROP INDEX "idx_charges_rate_by_range_or_minimum_amounts_deleted_at";
-- reverse: create "charges_rate_by_range_or_minimum_amounts" table
DROP TABLE "charges_rate_by_range_or_minimum_amounts";
-- reverse: create index "idx_org_branch_cpe_batch" to table: "cash_position_entry_transaction_batches"
DROP INDEX "idx_org_branch_cpe_batch";
-- reverse: create index "idx_cash_position_entry_transaction_batches_deleted_at" to table: "cash_position_entry_transaction_batches"
DROP INDEX "idx_cash_position_entry_transaction_batches_deleted_at";
-- reverse: create index "idx_cash_position_entry_transaction_batches_cash_positi348c4877" to table: "cash_position_entry_transaction_batches"
DROP INDEX "idx_cash_position_entry_transaction_batches_cash_positi348c4877";
-- reverse: create "cash_position_entry_transaction_batches" table
DROP TABLE "cash_position_entry_transaction_batches";
-- reverse: create index "idx_org_branch_cpe_online" to table: "cash_position_entry_online_remittances"
DROP INDEX "idx_org_branch_cpe_online";
-- reverse: create index "idx_cash_position_entry_online_remittances_deleted_at" to table: "cash_position_entry_online_remittances"
DROP INDEX "idx_cash_position_entry_online_remittances_deleted_at";
-- reverse: create index "idx_cash_position_entry_online_remittances_cash_positiobc03b300" to table: "cash_position_entry_online_remittances"
DROP INDEX "idx_cash_position_entry_online_remittances_cash_positiobc03b300";
-- reverse: create "cash_position_entry_online_remittances" table
DROP TABLE "cash_position_entry_online_remittances";
-- reverse: create index "idx_org_branch_cpe_check" to table: "cash_position_entry_check_remittances"
DROP INDEX "idx_org_branch_cpe_check";
-- reverse: create index "idx_cash_position_entry_check_remittances_deleted_at" to table: "cash_position_entry_check_remittances"
DROP INDEX "idx_cash_position_entry_check_remittances_deleted_at";
-- reverse: create index "idx_cash_position_entry_check_remittances_cash_positiona7184825" to table: "cash_position_entry_check_remittances"
DROP INDEX "idx_cash_position_entry_check_remittances_cash_positiona7184825";
-- reverse: create "cash_position_entry_check_remittances" table
DROP TABLE "cash_position_entry_check_remittances";
-- reverse: create index "idx_org_branch_cpe_cash_count" to table: "cash_position_entry_cash_counts"
DROP INDEX "idx_org_branch_cpe_cash_count";
-- reverse: create index "idx_cash_position_entry_cash_counts_deleted_at" to table: "cash_position_entry_cash_counts"
DROP INDEX "idx_cash_position_entry_cash_counts_deleted_at";
-- reverse: create index "idx_cash_position_entry_cash_counts_cash_position_entry_id" to table: "cash_position_entry_cash_counts"
DROP INDEX "idx_cash_position_entry_cash_counts_cash_position_entry_id";
-- reverse: create "cash_position_entry_cash_counts" table
DROP TABLE "cash_position_entry_cash_counts";
-- reverse: create index "idx_org_branch_cpe" to table: "cash_position_entries"
DROP INDEX "idx_org_branch_cpe";
-- reverse: create index "idx_cash_position_entries_deleted_at" to table: "cash_position_entries"
DROP INDEX "idx_cash_position_entries_deleted_at";
-- reverse: create "cash_position_entries" table
DROP TABLE "cash_position_entries";
-- reverse: create index "idx_organization_branch_cash_count" to table: "cash_counts"
DROP INDEX "idx_organization_branch_cash_count";
-- reverse: create index "idx_cash_counts_deleted_at" to table: "cash_counts"
DROP INDEX "idx_cash_counts_deleted_at";
-- reverse: create "cash_counts" table
DROP TABLE "cash_counts";
-- reverse: create index "idx_organization_branch_cash_check_voucher_tag" to table: "cash_check_voucher_tags"
DROP INDEX "idx_organization_branch_cash_check_voucher_tag";
-- reverse: create index "idx_cash_check_voucher_tags_deleted_at" to table: "cash_check_voucher_tags"
DROP INDEX "idx_cash_check_voucher_tags_deleted_at";
-- reverse: create "cash_check_voucher_tags" table
DROP TABLE "cash_check_voucher_tags";
-- reverse: create index "idx_organization_branch_cash_check_voucher_entry" to table: "cash_check_voucher_entries"
DROP INDEX "idx_organization_branch_cash_check_voucher_entry";
-- reverse: create index "idx_cash_check_voucher_entries_deleted_at" to table: "cash_check_voucher_entries"
DROP INDEX "idx_cash_check_voucher_entries_deleted_at";
-- reverse: create "cash_check_voucher_entries" table
DROP TABLE "cash_check_voucher_entries";
-- reverse: create index "idx_organization_branch_cash_check_voucher" to table: "cash_check_vouchers"
DROP INDEX "idx_organization_branch_cash_check_voucher";
-- reverse: create index "idx_cash_check_vouchers_deleted_at" to table: "cash_check_vouchers"
DROP INDEX "idx_cash_check_vouchers_deleted_at";
-- reverse: create "cash_check_vouchers" table
DROP TABLE "cash_check_vouchers";
-- reverse: create index "idx_organization_branch_cancelled_cash_check_voucher" to table: "cancelled_cash_check_vouchers"
DROP INDEX "idx_organization_branch_cancelled_cash_check_voucher";
-- reverse: create index "idx_cancelled_cash_check_vouchers_deleted_at" to table: "cancelled_cash_check_vouchers"
DROP INDEX "idx_cancelled_cash_check_vouchers_deleted_at";
-- reverse: create "cancelled_cash_check_vouchers" table
DROP TABLE "cancelled_cash_check_vouchers";
-- reverse: create index "idx_organization_branch_browse_reference" to table: "browse_references"
DROP INDEX "idx_organization_branch_browse_reference";
-- reverse: create index "idx_browse_references_deleted_at" to table: "browse_references"
DROP INDEX "idx_browse_references_deleted_at";
-- reverse: create "browse_references" table
DROP TABLE "browse_references";
-- reverse: create index "idx_organization_branch_browse_exclude_include_accounts" to table: "browse_exclude_include_accounts"
DROP INDEX "idx_organization_branch_browse_exclude_include_accounts";
-- reverse: create index "idx_browse_exclude_include_accounts_deleted_at" to table: "browse_exclude_include_accounts"
DROP INDEX "idx_browse_exclude_include_accounts_deleted_at";
-- reverse: create "browse_exclude_include_accounts" table
DROP TABLE "browse_exclude_include_accounts";
-- reverse: create index "idx_unique_name_org_branch" to table: "bill_and_coins"
DROP INDEX "idx_unique_name_org_branch";
-- reverse: create index "idx_organization_branch_bill_and_coins" to table: "bill_and_coins"
DROP INDEX "idx_organization_branch_bill_and_coins";
-- reverse: create index "idx_bill_and_coins_deleted_at" to table: "bill_and_coins"
DROP INDEX "idx_bill_and_coins_deleted_at";
-- reverse: create "bill_and_coins" table
DROP TABLE "bill_and_coins";
-- reverse: create index "idx_organization_branch_batch_funding" to table: "batch_fundings"
DROP INDEX "idx_organization_branch_batch_funding";
-- reverse: create index "idx_batch_fundings_deleted_at" to table: "batch_fundings"
DROP INDEX "idx_batch_fundings_deleted_at";
-- reverse: create "batch_fundings" table
DROP TABLE "batch_fundings";
-- reverse: create index "idx_organization_branch_automatic_loan_deduction" to table: "automatic_loan_deductions"
DROP INDEX "idx_organization_branch_automatic_loan_deduction";
-- reverse: create index "idx_automatic_loan_deductions_deleted_at" to table: "automatic_loan_deductions"
DROP INDEX "idx_automatic_loan_deductions_deleted_at";
-- reverse: create "automatic_loan_deductions" table
DROP TABLE "automatic_loan_deductions";
-- reverse: create index "idx_organization_branch_charges_rate_scheme" to table: "charges_rate_schemes"
DROP INDEX "idx_organization_branch_charges_rate_scheme";
-- reverse: create index "idx_charges_rate_schemes_deleted_at" to table: "charges_rate_schemes"
DROP INDEX "idx_charges_rate_schemes_deleted_at";
-- reverse: create "charges_rate_schemes" table
DROP TABLE "charges_rate_schemes";
-- reverse: create index "idx_organization_branch_area" to table: "areas"
DROP INDEX "idx_organization_branch_area";
-- reverse: create index "idx_areas_deleted_at" to table: "areas"
DROP INDEX "idx_areas_deleted_at";
-- reverse: create "areas" table
DROP TABLE "areas";
-- reverse: create index "idx_organization_branch_adjustment_entry_tag" to table: "adjustment_tags"
DROP INDEX "idx_organization_branch_adjustment_entry_tag";
-- reverse: create index "idx_adjustment_tags_deleted_at" to table: "adjustment_tags"
DROP INDEX "idx_adjustment_tags_deleted_at";
-- reverse: create "adjustment_tags" table
DROP TABLE "adjustment_tags";
-- reverse: create index "idx_organization_branch_adjustment_entry" to table: "adjustment_entries"
DROP INDEX "idx_organization_branch_adjustment_entry";
-- reverse: create index "idx_adjustment_entries_deleted_at" to table: "adjustment_entries"
DROP INDEX "idx_adjustment_entries_deleted_at";
-- reverse: create "adjustment_entries" table
DROP TABLE "adjustment_entries";
-- reverse: create index "idx_payment_types_deleted_at" to table: "payment_types"
DROP INDEX "idx_payment_types_deleted_at";
-- reverse: create index "idx_organization_branch_peyment_type" to table: "payment_types"
DROP INDEX "idx_organization_branch_peyment_type";
-- reverse: create index "idx_organization_branch_payment_type" to table: "payment_types"
DROP INDEX "idx_organization_branch_payment_type";
-- reverse: create "payment_types" table
DROP TABLE "payment_types";
-- reverse: create index "idx_organization_branch_loan_transaction" to table: "loan_transactions"
DROP INDEX "idx_organization_branch_loan_transaction";
-- reverse: create index "idx_loan_transactions_deleted_at" to table: "loan_transactions"
DROP INDEX "idx_loan_transactions_deleted_at";
-- reverse: create "loan_transactions" table
DROP TABLE "loan_transactions";
-- reverse: create index "idx_transaction_batches_deleted_at" to table: "transaction_batches"
DROP INDEX "idx_transaction_batches_deleted_at";
-- reverse: create index "idx_organization_branch_transaction_batch" to table: "transaction_batches"
DROP INDEX "idx_organization_branch_transaction_batch";
-- reverse: create "transaction_batches" table
DROP TABLE "transaction_batches";
-- reverse: create index "idx_unique_currency_per_branch_settings" to table: "unbalanced_accounts"
DROP INDEX "idx_unique_currency_per_branch_settings";
-- reverse: create index "idx_unbalanced_accounts_deleted_at" to table: "unbalanced_accounts"
DROP INDEX "idx_unbalanced_accounts_deleted_at";
-- reverse: create "unbalanced_accounts" table
DROP TABLE "unbalanced_accounts";
-- reverse: create index "idx_branch_settings_deleted_at" to table: "branch_settings"
DROP INDEX "idx_branch_settings_deleted_at";
-- reverse: create index "idx_branch_settings_branch_id" to table: "branch_settings"
DROP INDEX "idx_branch_settings_branch_id";
-- reverse: create "branch_settings" table
DROP TABLE "branch_settings";
-- reverse: create index "idx_revolving_funds_organization_id" to table: "revolving_funds"
DROP INDEX "idx_revolving_funds_organization_id";
-- reverse: create index "idx_revolving_funds_deleted_at" to table: "revolving_funds"
DROP INDEX "idx_revolving_funds_deleted_at";
-- reverse: create index "idx_revolving_funds_branch_id" to table: "revolving_funds"
DROP INDEX "idx_revolving_funds_branch_id";
-- reverse: create "revolving_funds" table
DROP TABLE "revolving_funds";
-- reverse: create index "idx_organization_branch_bank" to table: "banks"
DROP INDEX "idx_organization_branch_bank";
-- reverse: create index "idx_banks_deleted_at" to table: "banks"
DROP INDEX "idx_banks_deleted_at";
-- reverse: create "banks" table
DROP TABLE "banks";
-- reverse: create index "idx_organization_branch_loan_status" to table: "loan_statuses"
DROP INDEX "idx_organization_branch_loan_status";
-- reverse: create index "idx_loan_statuses_deleted_at" to table: "loan_statuses"
DROP INDEX "idx_loan_statuses_deleted_at";
-- reverse: create "loan_statuses" table
DROP TABLE "loan_statuses";
-- reverse: create index "idx_organization_branch_loan_purpose" to table: "loan_purposes"
DROP INDEX "idx_organization_branch_loan_purpose";
-- reverse: create index "idx_loan_purposes_deleted_at" to table: "loan_purposes"
DROP INDEX "idx_loan_purposes_deleted_at";
-- reverse: create "loan_purposes" table
DROP TABLE "loan_purposes";
-- reverse: create index "idx_organization_branch_member_accounting_ledger" to table: "member_accounting_ledgers"
DROP INDEX "idx_organization_branch_member_accounting_ledger";
-- reverse: create index "idx_member_accounting_ledgers_deleted_at" to table: "member_accounting_ledgers"
DROP INDEX "idx_member_accounting_ledgers_deleted_at";
-- reverse: create "member_accounting_ledgers" table
DROP TABLE "member_accounting_ledgers";
-- reverse: create index "idx_organization_branch_member_profile" to table: "member_profiles"
DROP INDEX "idx_organization_branch_member_profile";
-- reverse: create index "idx_member_profiles_deleted_at" to table: "member_profiles"
DROP INDEX "idx_member_profiles_deleted_at";
-- reverse: create index "idx_full_name" to table: "member_profiles"
DROP INDEX "idx_full_name";
-- reverse: create "member_profiles" table
DROP TABLE "member_profiles";
-- reverse: create index "idx_organization_branch_member_occupation" to table: "member_occupations"
DROP INDEX "idx_organization_branch_member_occupation";
-- reverse: create index "idx_member_occupations_deleted_at" to table: "member_occupations"
DROP INDEX "idx_member_occupations_deleted_at";
-- reverse: create "member_occupations" table
DROP TABLE "member_occupations";
-- reverse: create index "idx_organization_branch_member_group" to table: "member_groups"
DROP INDEX "idx_organization_branch_member_group";
-- reverse: create index "idx_member_groups_deleted_at" to table: "member_groups"
DROP INDEX "idx_member_groups_deleted_at";
-- reverse: create "member_groups" table
DROP TABLE "member_groups";
-- reverse: create index "idx_organization_branch_member_gender" to table: "member_genders"
DROP INDEX "idx_organization_branch_member_gender";
-- reverse: create index "idx_member_genders_deleted_at" to table: "member_genders"
DROP INDEX "idx_member_genders_deleted_at";
-- reverse: create "member_genders" table
DROP TABLE "member_genders";
-- reverse: create index "idx_organization_branch_member_department" to table: "member_departments"
DROP INDEX "idx_organization_branch_member_department";
-- reverse: create index "idx_member_departments_deleted_at" to table: "member_departments"
DROP INDEX "idx_member_departments_deleted_at";
-- reverse: create "member_departments" table
DROP TABLE "member_departments";
-- reverse: create index "idx_organization_branch_member_classification" to table: "member_classifications"
DROP INDEX "idx_organization_branch_member_classification";
-- reverse: create index "idx_member_classifications_deleted_at" to table: "member_classifications"
DROP INDEX "idx_member_classifications_deleted_at";
-- reverse: create "member_classifications" table
DROP TABLE "member_classifications";
-- reverse: create index "idx_organization_branch_member_center" to table: "member_centers"
DROP INDEX "idx_organization_branch_member_center";
-- reverse: create index "idx_member_centers_deleted_at" to table: "member_centers"
DROP INDEX "idx_member_centers_deleted_at";
-- reverse: create "member_centers" table
DROP TABLE "member_centers";
-- reverse: create index "idx_org_branch_account_tx_entry" to table: "account_transaction_entries"
DROP INDEX "idx_org_branch_account_tx_entry";
-- reverse: create index "idx_date_account_tx_entry" to table: "account_transaction_entries"
DROP INDEX "idx_date_account_tx_entry";
-- reverse: create index "idx_account_transaction_entries_deleted_at" to table: "account_transaction_entries"
DROP INDEX "idx_account_transaction_entries_deleted_at";
-- reverse: create index "idx_account_transaction_entries_account_transaction_id" to table: "account_transaction_entries"
DROP INDEX "idx_account_transaction_entries_account_transaction_id";
-- reverse: create index "idx_account_transaction_entries_account_id" to table: "account_transaction_entries"
DROP INDEX "idx_account_transaction_entries_account_id";
-- reverse: create "account_transaction_entries" table
DROP TABLE "account_transaction_entries";
-- reverse: create index "idx_org_branch_account_tx" to table: "account_transactions"
DROP INDEX "idx_org_branch_account_tx";
-- reverse: create index "idx_account_transactions_deleted_at" to table: "account_transactions"
DROP INDEX "idx_account_transactions_deleted_at";
-- reverse: create "account_transactions" table
DROP TABLE "account_transactions";
-- reverse: create index "idx_organization_branch_account_tag" to table: "account_tags"
DROP INDEX "idx_organization_branch_account_tag";
-- reverse: create index "idx_account_tags_deleted_at" to table: "account_tags"
DROP INDEX "idx_account_tags_deleted_at";
-- reverse: create "account_tags" table
DROP TABLE "account_tags";
-- reverse: create index "idx_account_history_org_branch" to table: "account_histories"
DROP INDEX "idx_account_history_org_branch";
-- reverse: create index "idx_account_history_account" to table: "account_histories"
DROP INDEX "idx_account_history_account";
-- reverse: create index "idx_account_histories_deleted_at" to table: "account_histories"
DROP INDEX "idx_account_histories_deleted_at";
-- reverse: create "account_histories" table
DROP TABLE "account_histories";
-- reverse: create index "idx_organization_branch_account" to table: "accounts"
DROP INDEX "idx_organization_branch_account";
-- reverse: create index "idx_accounts_deleted_at" to table: "accounts"
DROP INDEX "idx_accounts_deleted_at";
-- reverse: create index "idx_account_name_org_branch" to table: "accounts"
DROP INDEX "idx_account_name_org_branch";
-- reverse: create "accounts" table
DROP TABLE "accounts";
-- reverse: create index "idx_organization_branch_general_ledger_definition" to table: "general_ledger_definitions"
DROP INDEX "idx_organization_branch_general_ledger_definition";
-- reverse: create index "idx_general_ledger_definitions_deleted_at" to table: "general_ledger_definitions"
DROP INDEX "idx_general_ledger_definitions_deleted_at";
-- reverse: create "general_ledger_definitions" table
DROP TABLE "general_ledger_definitions";
-- reverse: create index "idx_organization_branch_member_type" to table: "member_types"
DROP INDEX "idx_organization_branch_member_type";
-- reverse: create index "idx_member_types_deleted_at" to table: "member_types"
DROP INDEX "idx_member_types_deleted_at";
-- reverse: create "member_types" table
DROP TABLE "member_types";
-- reverse: create index "idx_organization_branch_financial_title" to table: "financial_statement_titles"
DROP INDEX "idx_organization_branch_financial_title";
-- reverse: create index "idx_financial_statement_titles_deleted_at" to table: "financial_statement_titles"
DROP INDEX "idx_financial_statement_titles_deleted_at";
-- reverse: create "financial_statement_titles" table
DROP TABLE "financial_statement_titles";
-- reverse: create index "idx_organization_branch_computation_sheet" to table: "computation_sheets"
DROP INDEX "idx_organization_branch_computation_sheet";
-- reverse: create index "idx_computation_sheets_deleted_at" to table: "computation_sheets"
DROP INDEX "idx_computation_sheets_deleted_at";
-- reverse: create "computation_sheets" table
DROP TABLE "computation_sheets";
-- reverse: create index "idx_organization_branch_account_classification" to table: "account_classifications"
DROP INDEX "idx_organization_branch_account_classification";
-- reverse: create index "idx_account_classifications_deleted_at" to table: "account_classifications"
DROP INDEX "idx_account_classifications_deleted_at";
-- reverse: create "account_classifications" table
DROP TABLE "account_classifications";
-- reverse: create index "idx_organization_branch_account_category" to table: "account_categories"
DROP INDEX "idx_organization_branch_account_category";
-- reverse: create index "idx_account_categories_deleted_at" to table: "account_categories"
DROP INDEX "idx_account_categories_deleted_at";
-- reverse: create "account_categories" table
DROP TABLE "account_categories";
-- reverse: create index "idx_branches_deleted_at" to table: "branches"
DROP INDEX "idx_branches_deleted_at";
-- reverse: create "branches" table
DROP TABLE "branches";
-- reverse: create index "idx_organizations_deleted_at" to table: "organizations"
DROP INDEX "idx_organizations_deleted_at";
-- reverse: create "organizations" table
DROP TABLE "organizations";
-- reverse: create index "idx_subscription_plans_deleted_at" to table: "subscription_plans"
DROP INDEX "idx_subscription_plans_deleted_at";
-- reverse: create "subscription_plans" table
DROP TABLE "subscription_plans";
-- reverse: create index "idx_currencies_deleted_at" to table: "currencies"
DROP INDEX "idx_currencies_deleted_at";
-- reverse: create "currencies" table
DROP TABLE "currencies";
-- reverse: create index "idx_users_deleted_at" to table: "users"
DROP INDEX "idx_users_deleted_at";
-- reverse: create "users" table
DROP TABLE "users";
-- reverse: create index "idx_contact_us_deleted_at" to table: "contact_us"
DROP INDEX "idx_contact_us_deleted_at";
-- reverse: create "contact_us" table
DROP TABLE "contact_us";
-- reverse: create index "idx_media_deleted_at" to table: "media"
DROP INDEX "idx_media_deleted_at";
-- reverse: create "media" table
DROP TABLE "media";

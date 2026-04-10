package types

import (
	"github.com/google/uuid"
)

type (
	IDSRequest struct {
		IDs uuid.UUIDs `json:"ids"`
	}

	QRResult struct {
		Data string `json:"data"`
		Type string `json:"type"`
	}

	QRMemberProfile struct {
		FirstName       string `json:"first_name"`
		LastName        string `json:"last_name"`
		MiddleName      string `json:"middle_name"`
		FullName        string `json:"full_name"`
		ContactNumber   string `json:"contact_number"`
		MemberProfileID string `json:"member_profile_id"`
		BranchID        string `json:"branch_id"`
		OrganizationID  string `json:"organization_id"`
		Email           string `json:"email"`
	}

	QRInvitationCode struct {
		OrganizationID string `json:"organization_id"`
		BranchID       string `json:"branch_id"`
		UserType       string `json:"user_type"`
		Code           string `json:"code"`
		CurrentUse     int    `json:"current_use"`
		Description    string `json:"description"`
	}

	QRUser struct {
		UserID        string `json:"user_id"`
		Email         string `json:"email"`
		ContactNumber string `json:"contact_number"`
		Username      string `json:"user_name"`
		Name          string `json:"name"`
		Lastname      string `json:"last_name"`
		Firstname     string `json:"first_name"`
		Middlename    string `json:"middle_name"`
	}
)

func Models() ([]any, []any) {
	first := []any{
		AccountCategory{},
		AccountClassification{},
		Account{},
		AccountHistory{},
		AccountTag{},
		AdjustmentEntry{},
		AdjustmentTag{},
		AutomaticLoanDeduction{},
		Bank{},
		BatchFunding{},
		BillAndCoins{},
		Branch{},
		BranchSetting{},
		BrowseExcludeIncludeAccounts{},
		BrowseReference{},
		CancelledCashCheckVoucher{},
		CashCheckVoucherEntry{},
		CashCheckVoucher{},
		CashCheckVoucherTag{},
		CashCount{},
		Category{},
		ChargesRateByRangeOrMinimumAmount{},
		ChargesRateByTerm{},
		ChargesRateSchemeAccount{},
		ChargesRateScheme{},
		ChargesRateSchemeModeOfPayment{},
		CheckRemittance{},
		Collateral{},
		CollectorsMemberAccountEntry{},
		ComakerCollateral{},
		ComakerMemberProfile{},
		Company{},
		ComputationSheet{},
		ContactUs{},
		Currency{},
		Disbursement{},
		DisbursementTransaction{},
		Feedback{},
		FinesMaturity{},
		Footstep{},
		Funds{},
		GeneralAccountGroupingNetSurplusNegative{},
		GeneralAccountGroupingNetSurplusPositive{},
		GeneralAccountingLedgerTag{},
		GeneralLedgerDefinition{},
		GeneralLedger{},
		GeneratedReport{},
		GeneratedReportsDownloadUsers{},
		GeneratedSavingsInterestEntry{},
		GeneratedSavingsInterest{},
		GroceryComputationSheet{},
		GroceryComputationSheetMonthly{},
		Holiday{},
		IncludeNegativeAccount{},
		InterestMaturity{},
		InterestRateByAmount{},
		InterestRateByDate{},
		InterestRateByTerm{},
		InterestRateByYear{},
		InterestRatePercentage{},
		InterestRateScheme{},
		InvitationCode{},
		JournalVoucherEntry{},
		JournalVoucher{},
		JournalVoucherTag{},
		LoanAccount{},
		LoanClearanceAnalysis{},
		LoanClearanceAnalysisInstitution{},
		LoanComakerMember{},
		LoanGuaranteedFund{},
		LoanGuaranteedFundPerMonth{},
		LoanPurpose{},
		LoanStatus{},
		LoanTag{},
		LoanTermsAndConditionAmountReceipt{},
		LoanTermsAndConditionSuggestedPayment{},
		LoanTransactionEntry{},
		LoanTransaction{},
		Media{},
		MemberProfile{},
		MemberAddress{},
		MemberAsset{},
		MemberBankCard{},
		MemberCenter{},
		MemberCenterHistory{},
		MemberClassification{},
		MemberClassificationHistory{},
		MemberClassificationInterestRate{},
		MemberCloseRemark{},
		MemberContactReference{},
		MemberDamayanExtensionEntry{},
		MemberDeductionEntry{},
		MemberDepartment{},
		MemberDepartmentHistory{},
		MemberEducationalAttainment{},
		MemberExpense{},
		MemberGender{},
		MemberGenderHistory{},
		MemberGovernmentBenefit{},
		MemberGroup{},
		MemberGroupHistory{},
		MemberIncome{},
		MemberJointAccount{},
		MemberMutualFundHistory{},
		MemberOccupation{},
		MemberOccupationHistory{},
		MemberOtherInformationEntry{},
		MemberProfileArchive{},
		MemberProfileMedia{},
		MemberRelativeAccount{},
		MemberType{},
		MemberTypeHistory{},
		MemberVerification{},
		MutualFundAdditionalMembers{},
		MutualFundEntry{},
		MutualFund{},
		MutualFundTable{},
		Notification{},
		OnlineRemittance{},
		OrganizationCategory{},
		OrganizationDailyUsage{},
		Organization{},
		OrganizationMedia{},
		PaymentType{},
		PermissionTemplate{},
		PostDatedCheck{},
		SubscriptionPlan{},
		TagTemplate{},
		TimeDepositComputation{},
		TimeDepositComputationPreMature{},
		TimeDepositType{},
		Timesheet{},
		TransactionBatch{},
		Transaction{},
		TransactionTag{},
		UnbalancedAccount{},
		User{},
		UserOrganization{},
		UserRating{},
		VoucherPayTo{},
		AccountTransaction{},
		AccountTransactionEntry{},
		MemberAccountingLedger{},
		Area{},
		FeedMedia{},
		Feed{},
		FeedLike{},
		FeedComment{},
		FinancialStatementTitle{},

		InventoryHazard{},
		InventoryBrand{},
		InventoryCategory{},
		InventoryWarehouse{},
		InventorySupplier{},
		InventoryItem{},
		InventoryItemEntry{},
		InventoryTag{},

		CheckWarehousing{},
		CashPositionEntryCashCount{},
		CashPositionEntryCheckRemittance{},
		CashPositionEntryOnlineRemittance{},
		CashPositionEntryTransactionBatch{},
		CashPositionEntry{},

		OtherFund{},
		OtherFundEntry{},
		OtherFundTag{},

		RevolvingFund{},
		RevolvingFundCashCount{},
	}
	second := []any{}
	return first, second
}

func AdminModels() ([]any, []any) {
	first := []any{
		License{},
		Admin{},
	}
	second := []any{}
	return first, second
}

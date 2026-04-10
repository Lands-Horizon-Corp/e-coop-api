package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	CashPositionEntryTransactionBatch struct {
		ID          uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey" json:"id"`
		CreatedAt   time.Time      `gorm:"not null;default:now()" json:"created_at"`
		CreatedByID uuid.UUID      `gorm:"type:uuid" json:"created_by_id"`
		UpdatedAt   time.Time      `gorm:"not null;default:now()" json:"updated_at"`
		DeletedAt   gorm.DeletedAt `gorm:"index" json:"deleted_at"`

		// Parent Relationship
		CashPositionEntryID uuid.UUID          `gorm:"type:uuid;not null;index" json:"cash_position_entry_id"`
		CashPositionEntry   *CashPositionEntry `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"-"`

		// Reference to original Batch (Optional, for audit)
		TransactionBatchID uuid.UUID         `gorm:"type:uuid" json:"transaction_batch_id"`
		TransactionBatch   *TransactionBatch `gorm:"foreignKey:TransactionBatchID;constraint:OnDelete:SET NULL;" json:"transaction_batch,omitempty"`

		OrganizationID uuid.UUID `gorm:"type:uuid;not null;index:idx_org_branch_cpe_batch" json:"organization_id"`
		BranchID       uuid.UUID `gorm:"type:uuid;not null;index:idx_org_branch_cpe_batch" json:"branch_id"`

		EmployeeUserID *uuid.UUID `gorm:"type:uuid" json:"employee_user_id,omitempty"`
		EmployeeUser   *User      `gorm:"foreignKey:EmployeeUserID" json:"employee_user,omitempty"`

		// Exactly the same fields as TransactionBatch
		BatchName               string  `gorm:"type:varchar(50)" json:"batch_name"`
		TotalCashCollection     float64 `gorm:"type:decimal" json:"total_cash_collection"`
		TotalDepositEntry       float64 `gorm:"type:decimal" json:"total_deposit_entry"`
		BeginningBalance        float64 `gorm:"type:decimal" json:"beginning_balance"`
		DepositInBank           float64 `gorm:"type:decimal" json:"deposit_in_bank"`
		CashCountTotal          float64 `gorm:"type:decimal" json:"cash_count_total"`
		GrandTotal              float64 `gorm:"type:decimal" json:"grand_total"`
		PettyCash               float64 `gorm:"type:decimal" json:"petty_cash"`
		LoanReleases            float64 `gorm:"type:decimal" json:"loan_releases"`
		CashCheckVoucherTotal   float64 `gorm:"type:decimal" json:"cash_check_voucher_total"`
		TimeDepositWithdrawal   float64 `gorm:"type:decimal" json:"time_deposit_withdrawal"`
		SavingsWithdrawal       float64 `gorm:"type:decimal" json:"savings_withdrawal"`
		TotalCashHandled        float64 `gorm:"type:decimal" json:"total_cash_handled"`
		TotalSupposedRemmitance float64 `gorm:"type:decimal" json:"total_supposed_remmitance"`

		TotalCashOnHand               float64 `gorm:"type:decimal" json:"total_cash_on_hand"`
		TotalCheckRemittance          float64 `gorm:"type:decimal" json:"total_check_remittance"`
		TotalOnlineRemittance         float64 `gorm:"type:decimal" json:"total_online_remittance"`
		TotalDepositInBank            float64 `gorm:"type:decimal" json:"total_deposit_in_bank"`
		TotalActualRemittance         float64 `gorm:"type:decimal" json:"total_actual_remittance"`
		TotalActualSupposedComparison float64 `gorm:"type:decimal" json:"total_actual_supposed_comparison"`

		Description string `gorm:"type:text" json:"description"`

		// Signature/Approval status from the original batch
		IsClosed bool `gorm:"not null;default:false" json:"is_closed"`

		CurrencyID uuid.UUID  `gorm:"type:uuid;not null" json:"currency_id"`
		EndedAt    *time.Time `gorm:"type:timestamp" json:"ended_at"`
	}

	CashPositionEntryTransactionBatchResponse struct {
		ID                    uuid.UUID     `json:"id"`
		BatchName             string        `json:"batch_name"`
		EmployeeUserID        *uuid.UUID    `json:"employee_user_id,omitempty"`
		EmployeeUser          *UserResponse `json:"employee_user,omitempty"`
		GrandTotal            float64       `json:"grand_total"`
		TotalActualRemittance float64       `json:"total_actual_remittance"`
		IsClosed              bool          `json:"is_closed"`
	}
)

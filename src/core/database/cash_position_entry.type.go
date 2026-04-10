package types

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	CashPositionEntry struct {
		ID          uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey" json:"id"`
		CreatedAt   time.Time      `gorm:"not null;default:now()" json:"created_at"`
		CreatedByID uuid.UUID      `gorm:"type:uuid" json:"created_by_id"`
		CreatedBy   *User          `gorm:"foreignKey:CreatedByID;constraint:OnDelete:SET NULL;" json:"created_by,omitempty"`
		UpdatedAt   time.Time      `gorm:"not null;default:now()" json:"updated_at"`
		UpdatedByID uuid.UUID      `gorm:"type:uuid" json:"updated_by_id"`
		UpdatedBy   *User          `gorm:"foreignKey:UpdatedByID;constraint:OnDelete:SET NULL;" json:"updated_by,omitempty"`
		DeletedAt   gorm.DeletedAt `gorm:"index" json:"deleted_at"`
		DeletedByID *uuid.UUID     `gorm:"type:uuid" json:"deleted_by_id"`
		DeletedBy   *User          `gorm:"foreignKey:DeletedByID;constraint:OnDelete:SET NULL;" json:"deleted_by,omitempty"`

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_cpe" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_cpe" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		// Summary Metadata
		EntryDate   time.Time `gorm:"type:date;not null" json:"entry_date"`
		ReferenceNo string    `gorm:"type:varchar(50)" json:"reference_no"`
		Description string    `gorm:"type:text" json:"description"`

		// Aggregate Financials (Summarizing all batches)
		BeginningBalance        float64 `gorm:"type:decimal" json:"beginning_balance"`
		TotalCashIn             float64 `gorm:"type:decimal" json:"total_cash_in"`
		TotalCashOut            float64 `gorm:"type:decimal" json:"total_cash_out"`
		TotalCollections        float64 `gorm:"type:decimal" json:"total_collections"`
		TotalDisbursements      float64 `gorm:"type:decimal" json:"total_disbursements"`
		TotalBankDeposits       float64 `gorm:"type:decimal" json:"total_bank_deposits"`
		TotalPettyCash          float64 `gorm:"type:decimal" json:"total_petty_cash"`
		EndingBalanceCalculated float64 `gorm:"type:decimal" json:"ending_balance_calculated"`
		ActualCashOnHand        float64 `gorm:"type:decimal" json:"actual_cash_on_hand"`
		OverShortAmount         float64 `gorm:"type:decimal" json:"over_short_amount"`

		// --- ONE-TO-MANY RELATIONSHIPS ---
		CashCounts         []*CashPositionEntryCashCount        `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"cash_counts,omitempty"`
		TransactionBatches []*CashPositionEntryTransactionBatch `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"transaction_batches,omitempty"`
		OnlineRemittances  []*CashPositionEntryOnlineRemittance `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"online_remittances,omitempty"`
		CheckRemittances   []*CashPositionEntryCheckRemittance  `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"check_remittances,omitempty"`

		// Status and Control
		IsClosed   bool `gorm:"not null;default:false" json:"is_closed"`
		IsVerified bool `gorm:"not null;default:false" json:"is_verified"`

		// Signatures
		PreparedByName             string     `gorm:"type:varchar(255)" json:"prepared_by_name"`
		PreparedBySignatureMediaID *uuid.UUID `gorm:"type:uuid" json:"prepared_by_signature_media_id,omitempty"`
		PreparedBySignatureMedia   *Media     `gorm:"foreignKey:PreparedBySignatureMediaID" json:"prepared_by_signature_media,omitempty"`

		VerifiedByName             string     `gorm:"type:varchar(255)" json:"verified_by_name"`
		VerifiedBySignatureMediaID *uuid.UUID `gorm:"type:uuid" json:"verified_by_signature_media_id,omitempty"`
		VerifiedBySignatureMedia   *Media     `gorm:"foreignKey:VerifiedBySignatureMediaID" json:"verified_by_signature_media,omitempty"`

		ApprovedByName             string     `gorm:"type:varchar(255)" json:"approved_by_name"`
		ApprovedBySignatureMediaID *uuid.UUID `gorm:"type:uuid" json:"approved_by_signature_media_id,omitempty"`
		ApprovedBySignatureMedia   *Media     `gorm:"foreignKey:ApprovedBySignatureMediaID" json:"approved_by_signature_media,omitempty"`

		CurrencyID uuid.UUID `gorm:"type:uuid;not null" json:"currency_id"`
		Currency   *Currency `gorm:"foreignKey:CurrencyID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"currency,omitempty"`
	}

	CashPositionEntryResponse struct {
		ID                      uuid.UUID `json:"id"`
		CreatedAt               string    `json:"created_at"`
		OrganizationID          uuid.UUID `json:"organization_id"`
		BranchID                uuid.UUID `json:"branch_id"`
		EntryDate               string    `json:"entry_date"`
		ReferenceNo             string    `json:"reference_no"`
		BeginningBalance        float64   `json:"beginning_balance"`
		TotalCollections        float64   `json:"total_collections"`
		TotalDisbursements      float64   `json:"total_disbursements"`
		TotalBankDeposits       float64   `json:"total_bank_deposits"`
		EndingBalanceCalculated float64   `json:"ending_balance_calculated"`
		ActualCashOnHand        float64   `json:"actual_cash_on_hand"`
		OverShortAmount         float64   `json:"over_short_amount"`
		IsClosed                bool      `json:"is_closed"`
		PreparedByName          string    `json:"prepared_by_name"`
		VerifiedByName          string    `json:"verified_by_name"`
		ApprovedByName          string    `json:"approved_by_name"`
		IsToday                 bool      `json:"is_today"`

		CashCounts         []*CashPositionEntryCashCountResponse        `json:"cash_counts,omitempty"`
		TransactionBatches []*CashPositionEntryTransactionBatchResponse `json:"transaction_batches,omitempty"`
		OnlineRemittances  []*CashPositionEntryOnlineRemittanceResponse `json:"online_remittances,omitempty"`
		CheckRemittances   []*CashPositionEntryCheckRemittanceResponse  `json:"check_remittances,omitempty"`
	}

	CashPositionEntryRequest struct {
		EntryDate        time.Time `json:"entry_date" validate:"required"`
		ReferenceNo      string    `json:"reference_no" validate:"required"`
		BeginningBalance float64   `json:"beginning_balance"`
		ActualCashOnHand float64   `json:"actual_cash_on_hand"`
		Description      string    `json:"description,omitempty"`
		CurrencyID       uuid.UUID `json:"currency_id" validate:"required"`
	}
	CashPositionProcessRequest struct {
		Date                        *time.Time `json:"date"`
		DisabledTransactionBatchIDs uuid.UUIDs `json:"disabled_transaction_batch_ids"`
	}
)

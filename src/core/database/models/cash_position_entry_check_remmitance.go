package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	CashPositionEntryCheckRemittance struct {
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

		// Parent Relationship to CPE
		CashPositionEntryID uuid.UUID          `gorm:"type:uuid;not null;index" json:"cash_position_entry_id"`
		CashPositionEntry   *CashPositionEntry `gorm:"foreignKey:CashPositionEntryID;constraint:OnDelete:CASCADE;" json:"-"`

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_cpe_check" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_cpe_check" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		BankID  uuid.UUID  `gorm:"type:uuid;not null" json:"bank_id"`
		Bank    *Bank      `gorm:"foreignKey:BankID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"bank,omitempty"`
		MediaID *uuid.UUID `gorm:"type:uuid" json:"media_id"`
		Media   *Media     `gorm:"foreignKey:MediaID;constraint:OnDelete:SET NULL;" json:"media,omitempty"`

		// Optional references to original employee batch for audit
		EmployeeUserID     *uuid.UUID        `gorm:"type:uuid" json:"employee_user_id,omitempty"`
		EmployeeUser       *User             `gorm:"foreignKey:EmployeeUserID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"employee_user,omitempty"`
		TransactionBatchID *uuid.UUID        `gorm:"type:uuid" json:"transaction_batch_id,omitempty"`
		TransactionBatch   *TransactionBatch `gorm:"foreignKey:TransactionBatchID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"transaction_batch,omitempty"`

		CurrencyID      uuid.UUID  `gorm:"type:uuid;not null" json:"currency_id"`
		Currency        *Currency  `gorm:"foreignKey:CurrencyID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"currency,omitempty"`
		ReferenceNumber string     `gorm:"type:varchar(255)" json:"reference_number"` // Check Number
		AccountName     string     `gorm:"type:varchar(255)" json:"account_name"`     // Payer Name
		Amount          float64    `gorm:"type:decimal;not null" json:"amount"`
		DateEntry       *time.Time `gorm:"type:timestamp" json:"date_entry"`
		Description     string     `gorm:"type:text" json:"description"`
	}

	CashPositionEntryCheckRemittanceResponse struct {
		ID              uuid.UUID      `json:"id"`
		CreatedAt       string         `json:"created_at"`
		BankID          uuid.UUID      `json:"bank_id"`
		Bank            *BankResponse  `json:"bank,omitempty"`
		MediaID         *uuid.UUID     `json:"media_id,omitempty"`
		Media           *MediaResponse `json:"media,omitempty"`
		ReferenceNumber string         `json:"reference_number"`
		AccountName     string         `json:"account_name"`
		Amount          float64        `json:"amount"`
		DateEntry       *string        `json:"date_entry,omitempty"`
		Description     string         `json:"description"`
	}

	CashPositionEntryCheckRemittanceRequest struct {
		BankID             uuid.UUID  `json:"bank_id" validate:"required"`
		MediaID            *uuid.UUID `json:"media_id,omitempty"`
		CurrencyID         uuid.UUID  `json:"currency_id" validate:"required"`
		ReferenceNumber    string     `json:"reference_number,omitempty"`
		AccountName        string     `json:"account_name,omitempty"`
		Amount             float64    `json:"amount" validate:"required"`
		DateEntry          *time.Time `json:"date_entry,omitempty"`
		Description        string     `json:"description,omitempty"`
		TransactionBatchID *uuid.UUID `json:"transaction_batch_id,omitempty"`
	}
)

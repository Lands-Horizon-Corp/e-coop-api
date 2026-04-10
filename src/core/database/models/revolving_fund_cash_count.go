package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	RevolvingFundCashCount struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_rf_cash_count" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_rf_cash_count" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		RevolvingFundID uuid.UUID      `gorm:"type:uuid;not null;index" json:"revolving_fund_id"`
		RevolvingFund   *RevolvingFund `gorm:"foreignKey:RevolvingFundID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"revolving_fund,omitempty"`

		CurrencyID uuid.UUID `gorm:"type:uuid;not null" json:"currency_id"`
		Currency   *Currency `gorm:"foreignKey:CurrencyID;constraint:OnDelete:RESTRICT,OnUpdate:CASCADE;" json:"currency,omitempty"`

		Name       string  `gorm:"type:varchar(100);not null" json:"name"`
		BillAmount float64 `gorm:"type:decimal(15,2)" json:"bill_amount"`
		Quantity   int     `gorm:"type:int" json:"quantity"`
		Amount     float64 `gorm:"type:decimal(15,2)" json:"amount"`
	}

	RevolvingFundCashCountResponse struct {
		ID              uuid.UUID             `json:"id"`
		CreatedAt       string                `json:"created_at"`
		CreatedByID     uuid.UUID             `json:"created_by_id"`
		CreatedBy       *UserResponse         `json:"created_by,omitempty"`
		UpdatedAt       string                `json:"updated_at"`
		UpdatedByID     uuid.UUID             `json:"updated_by_id"`
		UpdatedBy       *UserResponse         `json:"updated_by,omitempty"`
		OrganizationID  uuid.UUID             `json:"organization_id"`
		Organization    *OrganizationResponse `json:"organization,omitempty"`
		BranchID        uuid.UUID             `json:"branch_id"`
		Branch          *BranchResponse       `json:"branch,omitempty"`
		RevolvingFundID uuid.UUID             `json:"revolving_fund_id"`
		CurrencyID      uuid.UUID             `json:"currency_id"`
		Currency        *CurrencyResponse     `json:"currency,omitempty"`
		Name            string                `json:"name"`
		BillAmount      float64               `json:"bill_amount"`
		Quantity        int                   `json:"quantity"`
		Amount          float64               `json:"amount"`
	}

	RevolvingFundCashCountRequest struct {
		ID              *uuid.UUID `json:"id,omitempty"`
		RevolvingFundID uuid.UUID  `json:"revolving_fund_id,omitempty"`
		CurrencyID      uuid.UUID  `json:"currency_id" validate:"required"`
		Name            string     `json:"name" validate:"required"`
		BillAmount      float64    `json:"bill_amount"`
		Quantity        int        `json:"quantity"`
		Amount          float64    `json:"amount"`
	}
)

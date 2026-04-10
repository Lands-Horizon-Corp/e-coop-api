package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	RevolvingFund struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE;" json:"branch,omitempty"`

		AccountID uuid.UUID `gorm:"type:uuid;not null" json:"account_id"`
		Account   *Bank     `gorm:"foreignKey:AccountID" json:"account,omitempty"`

		BeginningBalance              float64 `gorm:"type:decimal(15,2);default:0" json:"beginning_balance"`
		RevolvingFundBeginningBalance float64 `gorm:"type:decimal(15,2);default:0" json:"revolving_fund_beginning_balance"`
		AddReplenishment              float64 `gorm:"type:decimal(15,2);default:0" json:"add_replenishment"`
		Total                         float64 `gorm:"type:decimal(15,2);default:0" json:"total"`
		TotalLessDisbursements        float64 `gorm:"type:decimal(15,2);default:0" json:"total_less_disbursements"`
		Withdrawals                   float64 `gorm:"type:decimal(15,2);default:0" json:"withdrawals"`
		CashAdvance                   float64 `gorm:"type:decimal(15,2);default:0" json:"cash_advance"`
		RevolvingFundEndingTotal      float64 `gorm:"type:decimal(15,2);default:0" json:"revolving_fund_ending_total"`
		TotalRevolvingFundCountered   float64 `gorm:"type:decimal(15,2);default:0" json:"total_revolving_fund_countered"`
		TotalCheckRemittance          float64 `gorm:"type:decimal(15,2);default:0" json:"total_check_remittance"`

		BalanceStatus string `gorm:"type:varchar(50)" json:"balance_status"`
		IsClosed      bool   `gorm:"default:false" json:"is_closed"`
		CanView       bool   `gorm:"default:false" json:"can_view"`
		RequestView   bool   `gorm:"not null;default:false" json:"request_view"`

		RevolvingFundCashCount []*RevolvingFundCashCount `gorm:"foreignKey:RevolvingFundID" json:"revolving_fund_cash_count"`
	}

	RevolvingFundResponse struct {
		ID                            uuid.UUID                         `json:"id"`
		CreatedAt                     string                            `json:"created_at"`
		CreatedBy                     *UserResponse                     `json:"created_by,omitempty"`
		UpdatedAt                     string                            `json:"updated_at"`
		OrganizationID                uuid.UUID                         `json:"organization_id"`
		BranchID                      uuid.UUID                         `json:"branch_id"`
		AccountID                     uuid.UUID                         `json:"account_id"`
		BeginningBalance              float64                           `json:"beginning_balance"`
		RevolvingFundBeginningBalance float64                           `json:"revolving_fund_beginning_balance"`
		AddReplenishment              float64                           `json:"add_replenishment"`
		Total                         float64                           `json:"total"`
		TotalLessDisbursements        float64                           `json:"total_less_disbursements"`
		Withdrawals                   float64                           `json:"withdrawals"`
		CashAdvance                   float64                           `json:"cash_advance"`
		RevolvingFundEndingTotal      float64                           `json:"revolving_fund_ending_total"`
		TotalRevolvingFundCountered   float64                           `json:"total_revolving_fund_countered"`
		TotalCheckRemittance          float64                           `json:"total_check_remittance"`
		BalanceStatus                 string                            `json:"balance_status"`
		IsClosed                      bool                              `json:"is_closed"`
		IsToday                       bool                              `json:"is_today"`
		CanView                       bool                              `json:"can_view"`
		RequestView                   bool                              `json:"request_view"`
		RevolvingFundCashCount        []*RevolvingFundCashCountResponse `json:"revolving_fund_cash_count"`
	}

	RevolvingFundRequest struct {
		AccountID                     uuid.UUID                 `json:"account_id" validate:"required"`
		BeginningBalance              float64                   `json:"beginning_balance"`
		RevolvingFundBeginningBalance float64                   `json:"revolving_fund_beginning_balance"`
		AddReplenishment              float64                   `json:"add_replenishment"`
		Withdrawals                   float64                   `json:"withdrawals"`
		CashAdvance                   float64                   `json:"cash_advance"`
		IsClosed                      bool                      `json:"is_closed"`
		CanView                       bool                      `json:"can_view"`
		RequestView                   bool                      `json:"request_view,omitempty"`
		RevolvingFundCashCount        []*RevolvingFundCashCount `json:"revolving_fund_cash_count"`
	}

	RevolvingFundStartRequest struct {
		Name      string    `json:"name" validate:"required"`
		StartType string    `json:"start_type" validate:"required,oneof=actual supposed"`
		AccountID uuid.UUID `json:"account_id" validate:"required"`
	}
)

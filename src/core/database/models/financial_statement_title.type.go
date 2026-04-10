package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	FinancialStatementTitle struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_organization_branch_financial_title" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_organization_branch_financial_title" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		Title                    string `gorm:"type:varchar(255);not null" json:"title"`
		TotalTitle               string `gorm:"type:varchar(255);not null" json:"total_title"`
		ExcludeConsolidatedTotal bool   `gorm:"not null;default:false" json:"exclude_consolidated_total"`
		Index                    int    `gorm:"type:integer;not null;default:0" json:"index"`
		Color                    string `gorm:"type:varchar(50)" json:"color"`
	}

	FinancialStatementTitleResponse struct {
		ID                       uuid.UUID             `json:"id"`
		CreatedAt                string                `json:"created_at"`
		CreatedByID              uuid.UUID             `json:"created_by_id"`
		CreatedBy                *UserResponse         `json:"created_by,omitempty"`
		UpdatedAt                string                `json:"updated_at"`
		UpdatedByID              uuid.UUID             `json:"updated_by_id"`
		UpdatedBy                *UserResponse         `json:"updated_by,omitempty"`
		OrganizationID           uuid.UUID             `json:"organization_id"`
		Organization             *OrganizationResponse `json:"organization,omitempty"`
		BranchID                 uuid.UUID             `json:"branch_id"`
		Branch                   *BranchResponse       `json:"branch,omitempty"`
		Title                    string                `json:"title"`
		TotalTitle               string                `json:"total_title"`
		ExcludeConsolidatedTotal bool                  `json:"exclude_consolidated_total"`
		Index                    int                   `json:"index"`
		Color                    string                `json:"color"`
	}

	FinancialStatementTitleRequest struct {
		Title                    string `json:"title" validate:"required,min=1,max=255"`
		TotalTitle               string `json:"total_title" validate:"required,min=1,max=255"`
		ExcludeConsolidatedTotal bool   `json:"exclude_consolidated_total"`
		Index                    int    `json:"index"`
		Color                    string `json:"color" validate:"omitempty"`
	}
)

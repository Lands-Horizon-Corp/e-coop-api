package types

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	InventorySupplier struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_organization_branch_supplier" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_organization_branch_supplier" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		MediaID *uuid.UUID `gorm:"type:uuid" json:"media_id"`
		Media   *Media     `gorm:"foreignKey:MediaID;constraint:OnDelete:SET NULL;" json:"media,omitempty"`

		Name          string  `gorm:"type:varchar(255);not null" json:"name"`
		Description   string  `gorm:"type:text" json:"description"`
		Address       string  `gorm:"type:text" json:"address"`
		ContactNumber string  `gorm:"type:varchar(50)" json:"contact_number"`
		Longitude     float64 `gorm:"type:decimal(11,8)" json:"longitude"`
		Latitude      float64 `gorm:"type:decimal(10,8)" json:"latitude"`
		Icon          string  `gorm:"type:varchar(100)" json:"icon"`
	}

	InventorySupplierResponse struct {
		ID             uuid.UUID             `json:"id"`
		CreatedAt      string                `json:"created_at"`
		CreatedByID    uuid.UUID             `json:"created_by_id"`
		CreatedBy      *UserResponse         `json:"created_by,omitempty"`
		UpdatedAt      string                `json:"updated_at"`
		UpdatedByID    uuid.UUID             `json:"updated_by_id"`
		UpdatedBy      *UserResponse         `json:"updated_by,omitempty"`
		OrganizationID uuid.UUID             `json:"organization_id"`
		Organization   *OrganizationResponse `json:"organization,omitempty"`
		BranchID       uuid.UUID             `json:"branch_id"`
		Branch         *BranchResponse       `json:"branch,omitempty"`
		MediaID        *uuid.UUID            `json:"media_id,omitempty"`
		Media          *MediaResponse        `json:"media,omitempty"`
		Name           string                `json:"name"`
		Description    string                `json:"description"`
		Address        string                `json:"address"`
		ContactNumber  string                `json:"contact_number"`
		Longitude      float64               `json:"longitude"`
		Latitude       float64               `json:"latitude"`
		Icon           string                `json:"icon"`
	}

	InventorySupplierRequest struct {
		Name          string     `json:"name" validate:"required,min=1,max=255"`
		Description   string     `json:"description,omitempty"`
		Address       string     `json:"address,omitempty"`
		ContactNumber string     `json:"contact_number,omitempty"`
		Longitude     float64    `json:"longitude,omitempty"`
		Latitude      float64    `json:"latitude,omitempty"`
		MediaID       *uuid.UUID `json:"media_id,omitempty"`
		Icon          string     `json:"icon,omitempty"`
	}
)

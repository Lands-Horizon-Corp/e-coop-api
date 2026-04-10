package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	CheckWarehousing struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_check" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_check" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		MemberProfileID uuid.UUID      `gorm:"type:uuid;not null;index" json:"member_profile_id"`
		MemberProfile   *MemberProfile `gorm:"foreignKey:MemberProfileID;constraint:OnDelete:CASCADE;" json:"member_profile,omitempty"`
		BankID          uuid.UUID      `gorm:"type:uuid;not null;index" json:"bank_id"`
		Bank            *Bank          `gorm:"foreignKey:BankID;constraint:OnDelete:RESTRICT;" json:"bank,omitempty"`
		EmployeeUserID  uuid.UUID      `gorm:"type:uuid;not null" json:"employee_user_id"`
		EmployeeUser    *User          `gorm:"foreignKey:EmployeeUserID;constraint:OnDelete:SET NULL;" json:"employee_user,omitempty"`
		MediaID         *uuid.UUID     `gorm:"type:uuid" json:"media_id"`
		Media           *Media         `gorm:"foreignKey:MediaID;constraint:OnDelete:SET NULL;" json:"media,omitempty"`

		CheckNumber     string     `gorm:"type:varchar(255);not null;index" json:"check_number"`
		CheckDate       time.Time  `gorm:"type:date;not null" json:"check_date"`
		ClearDays       int        `gorm:"type:int;not null;default:0" json:"clear_days"`
		DateCleared     *time.Time `gorm:"type:date" json:"date_cleared"`
		Amount          float64    `gorm:"type:numeric(15,2);not null" json:"amount"`
		ReferenceNumber string     `gorm:"type:varchar(255);index" json:"reference_number"`
		Date            time.Time  `gorm:"type:date;not null" json:"date"`
		Description     string     `gorm:"type:text" json:"description"`
	}

	CheckWarehousingResponse struct {
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

		MemberProfileID uuid.UUID              `json:"member_profile_id"`
		MemberProfile   *MemberProfileResponse `json:"member_profile,omitempty"`
		BankID          uuid.UUID              `json:"bank_id"`
		Bank            *BankResponse          `json:"bank,omitempty"`
		EmployeeUserID  uuid.UUID              `json:"employee_user_id"`
		EmployeeUser    *UserResponse          `json:"employee_user,omitempty"`
		MediaID         *uuid.UUID             `json:"media_id,omitempty"`
		Media           *MediaResponse         `json:"media,omitempty"`

		CheckNumber     string  `json:"check_number"`
		CheckDate       string  `json:"check_date"`
		ClearDays       int     `json:"clear_days"`
		DateCleared     *string `json:"date_cleared,omitempty"`
		Amount          float64 `json:"amount"`
		ReferenceNumber string  `json:"reference_number"`
		Date            string  `json:"date"`
		Description     string  `json:"description"`

		IsToday  bool `json:"is_today"`
		IsPast   bool `json:"is_past"`
		IsFuture bool `json:"is_future"`
	}

	CheckWarehousingRequest struct {
		MemberProfileID uuid.UUID `json:"member_profile_id" validate:"required"`
		BankID          uuid.UUID `json:"bank_id" validate:"required"`
		EmployeeUserID  uuid.UUID `json:"employee_user_id" validate:"required"`
		CheckNumber     string    `json:"check_number" validate:"required,max=255"`
		ClearDays       int       `json:"clear_days" validate:"min=0"`
		Amount          float64   `json:"amount" validate:"required,gt=0"`
		ReferenceNumber string    `json:"reference_number,omitempty" validate:"max=255"`

		Description string     `json:"description,omitempty"`
		MediaID     *uuid.UUID `json:"media_id,omitempty"`

		CheckDate   time.Time `json:"check_date" validate:"required"`
		Date        time.Time `json:"date" validate:"required"`
		DateCleared time.Time `json:"date_cleared" validate:"required"`
	}

	CheckWarehousingSummary struct {
		TotalAmount             float64 `json:"total_amount"`
		TotalClearedAmount      float64 `json:"total_cleared_amount"`
		TotalChecksCount        int64   `json:"total_checks_count"`
		TotalChecksClearedCount int64   `json:"total_checks_cleared_count"`
	}
)

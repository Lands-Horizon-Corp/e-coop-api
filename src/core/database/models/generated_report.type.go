package types

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
	"gorm.io/gorm"
)

const (
	GeneratedReportStatusPending      GeneratedReportStatus = "pending"
	GeneratedReportStatusInProgress   GeneratedReportStatus = "in_progress"
	GeneratedReportStatusInFormatting GeneratedReportStatus = "formatting"
	GeneratedReportStatusInUploading  GeneratedReportStatus = "uploading"
	GeneratedReportStatusCompleted    GeneratedReportStatus = "completed"
	GeneratedReportStatusFailed       GeneratedReportStatus = "failed"

	ReportOrientationPortrait  ReportOrientation = "portrait"
	ReportOrientationLandscape ReportOrientation = "landscape"
)

type (
	GeneratedReportStatus string

	ReportOrientation string
	GeneratedReport   struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_branch_org_generated_report" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_branch_org_generated_report" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE;" json:"branch,omitempty"`

		UserID  *uuid.UUID `gorm:"type:uuid" json:"user_id,omitempty"`
		User    *User      `gorm:"foreignKey:UserID;constraint:OnDelete:SET NULL;" json:"user,omitempty"`
		MediaID *uuid.UUID `gorm:"type:uuid" json:"media_id,omitempty"`
		Media   *Media     `gorm:"foreignKey:MediaID" json:"media,omitempty"`

		Name          string                `gorm:"type:varchar(255);not null" json:"name"`
		Description   string                `gorm:"type:text" json:"description"`
		Status        GeneratedReportStatus `gorm:"type:varchar(50);not null" json:"status"`
		SystemMessage string                `gorm:"type:text" json:"system_message,omitempty"`

		IsFavorite bool `gorm:"type:boolean;default:false" json:"is_favorite"`

		Module   string `gorm:"type:varchar(255)" json:"module,omitempty"`
		Template string `gorm:"type:text;default:''" json:"template,omitempty"`

		Width       string            `gorm:"type:varchar(50)" json:"width,omitempty"`
		Height      string            `gorm:"type:varchar(50)" json:"height,omitempty"`
		Orientation ReportOrientation `gorm:"type:varchar(50);default:'portrait'" json:"orientation"`

		Password      string                           `gorm:"-" json:"password,omitempty"`
		Landscape     bool                             `gorm:"type:boolean;default:false" json:"landscape,omitempty"`
		DownloadUsers []*GeneratedReportsDownloadUsers `gorm:"foreignKey:GeneratedReportID" json:"download_users,omitempty"`

		Filters     datatypes.JSON `gorm:"type:jsonb;default:'{}'" json:"filters"`
		HasPassword bool           `gorm:"type:boolean;default:false" json:"has_password"`

		ExpirationDays int `gorm:"type:int;default:7" json:"expiration_days"`
	}

	GeneratedReportResponse struct {
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

		UserID  *uuid.UUID     `json:"user_id"`
		User    *UserResponse  `json:"user"`
		MediaID *uuid.UUID     `json:"media_id"`
		Media   *MediaResponse `json:"media,omitempty"`

		Status     GeneratedReportStatus `json:"status"`
		IsFavorite bool                  `json:"is_favorite"`

		Name        string `json:"name"`
		Description string `json:"description"`

		Module        string `json:"module,omitempty"`
		Template      string `json:"template,omitempty"`
		Width         string `json:"width,omitempty"`
		Height        string `json:"height,omitempty"`
		SystemMessage string `json:"system_message,omitempty"`

		DownloadUsers []*GeneratedReportsDownloadUsersResponse `json:"download_users,omitempty"`
		Filters       datatypes.JSON                           `json:"filters,omitempty"`
		HasPassword   bool                                     `json:"has_password"`
		Orientation   ReportOrientation                        `json:"orientation"`
	}

	GeneratedReportRequest struct {
		Name           string            `json:"name" validate:"required,min=1,max=255"`
		Password       string            `json:"password,omitempty"`
		Module         string            `json:"module" validate:"required,min=1"`
		Template       string            `json:"template" validate:"required,min=1"`
		Width          string            `json:"width,omitempty"`
		Height         string            `json:"height,omitempty"`
		Filters        datatypes.JSON    `json:"filters,omitempty"`
		ExpirationDays int               `gorm:"type:int;default:7" json:"expiration_days"`
		Orientation    ReportOrientation `json:"orientation"`
	}

	GeneratedReportExtendedRequest struct {
		ReportConfig *GeneratedReportRequest `json:"report_config" validate:"required"`
	}

	GeneratedReportUpdateRequest struct {
		Name        string `json:"name" validate:"required,min=1,max=255"`
		Description string `json:"description" validate:"required,min=1"`
	}

	GeneratedReportAvailableModulesResponse struct {
		Module string `json:"module"`
		Count  int    `json:"count"`
	}
)

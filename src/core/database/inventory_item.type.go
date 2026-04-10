package types

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type (
	InventoryItem struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_item" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_item" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		CategoryID  *uuid.UUID          `gorm:"type:uuid" json:"category_id"`
		Category    *InventoryCategory  `gorm:"foreignKey:CategoryID;constraint:OnDelete:SET NULL;" json:"category,omitempty"`
		BrandID     *uuid.UUID          `gorm:"type:uuid" json:"brand_id"`
		Brand       *InventoryBrand     `gorm:"foreignKey:BrandID;constraint:OnDelete:SET NULL;" json:"brand,omitempty"`
		WarehouseID *uuid.UUID          `gorm:"type:uuid" json:"warehouse_id"`
		Warehouse   *InventoryWarehouse `gorm:"foreignKey:WarehouseID;constraint:OnDelete:SET NULL;" json:"warehouse,omitempty"`
		SupplierID  *uuid.UUID          `gorm:"type:uuid" json:"supplier_id"`
		Supplier    *InventorySupplier  `gorm:"foreignKey:SupplierID;constraint:OnDelete:SET NULL;" json:"supplier,omitempty"`
		HazardID    *uuid.UUID          `gorm:"type:uuid" json:"hazard_id"`
		Hazard      *InventoryHazard    `gorm:"foreignKey:HazardID;constraint:OnDelete:SET NULL;" json:"hazard,omitempty"`
		MediaID     *uuid.UUID          `gorm:"type:uuid" json:"media_id"`
		Media       *Media              `gorm:"foreignKey:MediaID;constraint:OnDelete:SET NULL;" json:"media,omitempty"`

		Name          string  `gorm:"type:varchar(255);not null" json:"name"`
		Description   string  `gorm:"type:text" json:"description"`
		SerialNumber  string  `gorm:"type:varchar(100)" json:"serial_number"`
		Unit          string  `gorm:"type:varchar(50)" json:"unit"`
		TotalQuantity float64 `gorm:"type:decimal(15,2);default:0" json:"total_quantity"`
		TotalPrice    float64 `gorm:"type:decimal(15,2);default:0" json:"total_price"`

		// Extensive Barcode Support (Expanded)
		Barcode39                 string `gorm:"type:varchar(100)" json:"barcode_39"`
		BarcodeEan8               string `gorm:"type:varchar(8)" json:"barcode_ean_8"`
		BarcodeEan13              string `gorm:"type:varchar(13)" json:"barcode_ean_13"`
		BarcodeUpcA               string `gorm:"type:varchar(12)" json:"barcode_upc_a"`
		BarcodeUpcE               string `gorm:"type:varchar(6)" json:"barcode_upc_e"`
		BarcodeCode128            string `gorm:"type:varchar(100)" json:"barcode_code_128"`
		BarcodeItf14              string `gorm:"type:varchar(14)" json:"barcode_itf_14"`
		BarcodeQrCode             string `gorm:"type:text" json:"barcode_qr_code"`
		BarcodePdf417             string `gorm:"type:text" json:"barcode_pdf_417"`
		BarcodeAztec              string `gorm:"type:text" json:"barcode_aztec"`
		BarcodeDataMatrix         string `gorm:"type:text" json:"barcode_data_matrix"`
		BarcodeGs1DataBarExpanded string `gorm:"type:text" json:"barcode_gs1_data_bar_expanded"`
		BarcodeGs1DataMatrix      string `gorm:"type:text" json:"barcode_gs1_data_matrix"`

		Tags []*InventoryTag `gorm:"foreignKey:InventoryItemID" json:"tags,omitempty"`
	}

	InventoryItemResponse struct {
		ID             uuid.UUID                   `json:"id"`
		CreatedAt      string                      `json:"created_at"`
		CreatedByID    uuid.UUID                   `json:"created_by_id"`
		CreatedBy      *UserResponse               `json:"created_by,omitempty"`
		OrganizationID uuid.UUID                   `json:"organization_id"`
		Organization   *OrganizationResponse       `json:"organization,omitempty"`
		BranchID       uuid.UUID                   `json:"branch_id"`
		Branch         *BranchResponse             `json:"branch,omitempty"`
		CategoryID     *uuid.UUID                  `json:"category_id,omitempty"`
		Category       *InventoryCategoryResponse  `json:"category,omitempty"`
		BrandID        *uuid.UUID                  `json:"brand_id,omitempty"`
		Brand          *InventoryBrandResponse     `json:"brand,omitempty"`
		WarehouseID    *uuid.UUID                  `json:"warehouse_id,omitempty"`
		Warehouse      *InventoryWarehouseResponse `json:"warehouse,omitempty"`
		SupplierID     *uuid.UUID                  `json:"supplier_id,omitempty"`
		Supplier       *InventorySupplierResponse  `json:"supplier,omitempty"`
		HazardID       *uuid.UUID                  `json:"hazard_id,omitempty"`
		Hazard         *InventoryHazardResponse    `json:"hazard,omitempty"`
		MediaID        *uuid.UUID                  `json:"media_id,omitempty"`
		Media          *MediaResponse              `json:"media,omitempty"`

		Name          string  `json:"name"`
		Description   string  `json:"description"`
		SerialNumber  string  `json:"serial_number"`
		Unit          string  `json:"unit"`
		TotalQuantity float64 `json:"total_quantity"`
		TotalPrice    float64 `json:"total_price"`

		Barcode39                 string `json:"barcode_39,omitempty"`
		BarcodeEan8               string `json:"barcode_ean_8,omitempty"`
		BarcodeEan13              string `json:"barcode_ean_13,omitempty"`
		BarcodeUpcA               string `json:"barcode_upc_a,omitempty"`
		BarcodeUpcE               string `json:"barcode_upc_e,omitempty"`
		BarcodeCode128            string `json:"barcode_code_128,omitempty"`
		BarcodeItf14              string `json:"barcode_itf_14,omitempty"`
		BarcodeQrCode             string `json:"barcode_qr_code,omitempty"`
		BarcodePdf417             string `json:"barcode_pdf_417,omitempty"`
		BarcodeAztec              string `json:"barcode_aztec,omitempty"`
		BarcodeDataMatrix         string `json:"barcode_data_matrix,omitempty"`
		BarcodeGs1DataBarExpanded string `json:"barcode_gs1_data_bar_expanded,omitempty"`
		BarcodeGs1DataMatrix      string `json:"barcode_gs1_data_matrix,omitempty"`

		Tags []*InventoryTagResponse `json:"tags,omitempty"`
	}

	InventoryItemRequest struct {
		Name        string     `json:"name" validate:"required"`
		Description string     `json:"description,omitempty"`
		CategoryID  *uuid.UUID `json:"category_id,omitempty"`
		BrandID     *uuid.UUID `json:"brand_id,omitempty"`
		WarehouseID *uuid.UUID `json:"warehouse_id,omitempty"`
		SupplierID  *uuid.UUID `json:"supplier_id,omitempty"`
		HazardID    *uuid.UUID `json:"hazard_id,omitempty"`
		MediaID     *uuid.UUID `json:"media_id,omitempty"`

		Unit          string  `json:"unit,omitempty"`
		SerialNumber  string  `json:"serial_number,omitempty"`
		TotalQuantity float64 `json:"total_quantity"`
		TotalPrice    float64 `json:"total_price"`

		Barcode39                 string `json:"barcode_39,omitempty"`
		BarcodeEan8               string `json:"barcode_ean_8,omitempty"`
		BarcodeEan13              string `json:"barcode_ean_13,omitempty"`
		BarcodeUpcA               string `json:"barcode_upc_a,omitempty"`
		BarcodeUpcE               string `json:"barcode_upc_e,omitempty"`
		BarcodeCode128            string `json:"barcode_code_128,omitempty"`
		BarcodeItf14              string `json:"barcode_itf_14,omitempty"`
		BarcodeQrCode             string `json:"barcode_qr_code,omitempty"`
		BarcodePdf417             string `json:"barcode_pdf_417,omitempty"`
		BarcodeAztec              string `json:"barcode_aztec,omitempty"`
		BarcodeDataMatrix         string `json:"barcode_data_matrix,omitempty"`
		BarcodeGs1DataBarExpanded string `json:"barcode_gs1_data_bar_expanded,omitempty"`
		BarcodeGs1DataMatrix      string `json:"barcode_gs1_data_matrix,omitempty"`
	}

	InventoryUnifiedStockRequest struct {
		InventoryItemID *uuid.UUID `json:"inventory_item_id,omitempty"`

		Name       string     `json:"name"`
		Barcode    string     `json:"barcode"`
		CategoryID *uuid.UUID `json:"category_id"`
		BrandID    *uuid.UUID `json:"brand_id"`
		Unit       string     `json:"unit"`

		Quantity    float64    `json:"quantity" validate:"required,gt=0"`
		UnitCost    float64    `json:"unit_cost"`
		WarehouseID *uuid.UUID `json:"warehouse_id"`
		SupplierID  *uuid.UUID `json:"supplier_id"`
		Description string     `json:"description"`

		StatusIn  *StatusIn  `json:"status_in"`
		StatusOut *StatusOut `json:"status_out"`
	}
)

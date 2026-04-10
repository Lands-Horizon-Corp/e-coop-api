package types

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

const (
	UnitMicrogram         TUnit = "microgram"
	UnitMilligram         TUnit = "milligram"
	UnitCentigram         TUnit = "centigram"
	UnitDecigram          TUnit = "decigram"
	UnitGram              TUnit = "gram"
	UnitDekagram          TUnit = "dekagram"
	UnitHectogram         TUnit = "hectogram"
	UnitKilogram          TUnit = "kilogram"
	UnitMetricTon         TUnit = "metric_ton"
	UnitGrain             TUnit = "grain"
	UnitDram              TUnit = "dram"
	UnitOunce             TUnit = "ounce"
	UnitPound             TUnit = "pound"
	UnitStone             TUnit = "stone"
	UnitQuarter           TUnit = "quarter"
	UnitHundredweight     TUnit = "hundredweight"
	UnitLongHundredweight TUnit = "long_hundredweight"
	UnitShortTon          TUnit = "short_ton"
	UnitLongTon           TUnit = "long_ton"
	UnitAtomicMassUnit    TUnit = "atomic_mass_unit"
	UnitDalton            TUnit = "dalton"
	UnitNA                TUnit = "n/a"

	StatusInDraft     StatusIn = "draft"
	StatusInPending   StatusIn = "pending"
	StatusInApproved  StatusIn = "approved"
	StatusInReceiving StatusIn = "receiving"
	StatusInReceived  StatusIn = "received"
	StatusInCancelled StatusIn = "cancelled"
	StatusInMissing   StatusIn = "missing"

	StatusOutDraft          StatusOut = "draft"
	StatusOutPending        StatusOut = "pending"
	StatusOutApproved       StatusOut = "approved"
	StatusOutPicking        StatusOut = "picking"
	StatusOutOutForDelivery StatusOut = "out_for_delivery"
	StatusOutDelivered      StatusOut = "delivered"
	StatusOutCancelled      StatusOut = "cancelled"
)

type (
	TUnit              string
	StatusIn           string
	StatusOut          string
	InventoryItemEntry struct {
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

		OrganizationID uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_item_entry" json:"organization_id"`
		Organization   *Organization `gorm:"foreignKey:OrganizationID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"organization,omitempty"`
		BranchID       uuid.UUID     `gorm:"type:uuid;not null;index:idx_org_branch_item_entry" json:"branch_id"`
		Branch         *Branch       `gorm:"foreignKey:BranchID;constraint:OnDelete:CASCADE,OnUpdate:CASCADE;" json:"branch,omitempty"`

		InventoryItemID uuid.UUID      `gorm:"type:uuid;not null" json:"inventory_item_id"`
		InventoryItem   *InventoryItem `gorm:"foreignKey:InventoryItemID;constraint:OnDelete:CASCADE;" json:"inventory_item,omitempty"`

		WarehouseID *uuid.UUID          `gorm:"type:uuid" json:"warehouse_id"`
		Warehouse   *InventoryWarehouse `gorm:"foreignKey:WarehouseID" json:"warehouse,omitempty"`
		SupplierID  *uuid.UUID          `gorm:"type:uuid" json:"supplier_id"`
		Supplier    *InventorySupplier  `gorm:"foreignKey:SupplierID" json:"supplier,omitempty"`

		HazardID *uuid.UUID       `gorm:"type:uuid" json:"hazard_id"`
		Hazard   *InventoryHazard `gorm:"foreignKey:HazardID" json:"hazard,omitempty"`

		DebitAccountID  *uuid.UUID `gorm:"type:uuid" json:"debit_account_id"`
		DebitAccount    *Account   `gorm:"foreignKey:DebitAccountID" json:"debit_account,omitempty"`
		Debit           float64    `gorm:"type:decimal(15,2);default:0" json:"debit"`
		CreditAccountID *uuid.UUID `gorm:"type:uuid" json:"credit_account_id"`
		CreditAccount   *Account   `gorm:"foreignKey:CreditAccountID" json:"credit_account,omitempty"`
		Credit          float64    `gorm:"type:decimal(15,2);default:0" json:"credit"`

		Quantity         float64 `gorm:"type:decimal(15,2);not null" json:"quantity"`
		Weight           float64 `gorm:"type:decimal(15,2)" json:"weight"`
		Unit             TUnit   `gorm:"type:varchar(50)" json:"unit"`
		DimensionsWidth  float64 `gorm:"type:decimal(15,2)" json:"dimensions_width"`
		DimensionsLength float64 `gorm:"type:decimal(15,2)" json:"dimensions_length"`
		DimensionsHeight float64 `gorm:"type:decimal(15,2)" json:"dimensions_height"`
		ShippingCategory int     `json:"shipping_category"`
		Description      string  `gorm:"type:text" json:"description"`

		StatusIn        StatusIn  `gorm:"type:varchar(50)" json:"status_in"`
		StatusOut       StatusOut `gorm:"type:varchar(50)" json:"status_out"`
		CurrentLocation string    `gorm:"type:varchar(255)" json:"current_location"`
		Longitude       float64   `gorm:"type:decimal(11,8)" json:"longitude"`
		Latitude        float64   `gorm:"type:decimal(10,8)" json:"latitude"`
	}

	InventoryItemEntryResponse struct {
		ID               uuid.UUID                   `json:"id"`
		CreatedAt        string                      `json:"created_at"`
		InventoryItem    *InventoryItemResponse      `json:"inventory_item,omitempty"`
		Warehouse        *InventoryWarehouseResponse `json:"warehouse,omitempty"`
		Supplier         *InventorySupplierResponse  `json:"supplier,omitempty"`
		Debit            float64                     `json:"debit"`
		Credit           float64                     `json:"credit"`
		Quantity         float64                     `json:"quantity"`
		StatusIn         StatusIn                    `json:"status_in"`
		StatusOut        StatusOut                   `json:"status_out"`
		Unit             TUnit                       `json:"unit"`
		DimensionsWidth  float64                     `json:"dimensions_width,omitempty"`
		DimensionsLength float64                     `json:"dimensions_length,omitempty"`
		DimensionsHeight float64                     `json:"dimensions_height,omitempty"`
		Weight           float64                     `json:"weight,omitempty"`
		Description      string                      `json:"description"`
		Longitude        float64                     `json:"longitude"`
		Latitude         float64                     `json:"latitude"`
		CurrentLocation  string                      `json:"current_location"`
	}

	InventoryItemEntryRequest struct {
		InventoryItemID  uuid.UUID  `json:"inventory_item_id" validate:"required"`
		WarehouseID      *uuid.UUID `json:"warehouse_id,omitempty"`
		SupplierID       *uuid.UUID `json:"supplier_id,omitempty"`
		DebitAccountID   *uuid.UUID `json:"debit_account_id,omitempty"`
		CreditAccountID  *uuid.UUID `json:"credit_account_id,omitempty"`
		Quantity         float64    `json:"quantity" validate:"required"`
		Debit            float64    `json:"debit"`
		Credit           float64    `json:"credit"`
		StatusIn         StatusIn   `json:"status_in"`
		StatusOut        StatusOut  `json:"status_out"`
		Unit             TUnit      `json:"unit"`
		DimensionsWidth  float64    `json:"dimensions_width,omitempty"`
		DimensionsLength float64    `json:"dimensions_length,omitempty"`
		DimensionsHeight float64    `json:"dimensions_height,omitempty"`
		Weight           float64    `json:"weight,omitempty"`
		Description      string     `json:"description,omitempty"`
		Longitude        float64    `json:"longitude,omitempty"`
		Latitude         float64    `json:"latitude,omitempty"`
	}
)

var statusInOrder = []StatusIn{
	StatusInDraft,
	StatusInPending,
	StatusInApproved,
	StatusInReceiving,
	StatusInReceived,
}

var statusOutOrder = []StatusOut{
	StatusOutDraft,
	StatusOutPending,
	StatusOutApproved,
	StatusOutPicking,
	StatusOutOutForDelivery,
	StatusOutDelivered,
}

func (e *InventoryItemEntry) IsLocked() bool {
	if e.StatusIn == StatusInReceived || e.StatusIn == StatusInCancelled || e.StatusIn == StatusInMissing {
		return true
	}
	if e.StatusOut == StatusOutDelivered || e.StatusOut == StatusOutCancelled {
		return true
	}
	return false
}

func (e *InventoryItemEntry) TransitionStatusIn(forward bool) error {
	if e.IsLocked() {
		return errors.New("cannot transition status: entry is in a terminal state (Received/Cancelled/Missing)")
	}

	currentIndex := -1
	for i, s := range statusInOrder {
		if s == e.StatusIn {
			currentIndex = i
			break
		}
	}
	if currentIndex == -1 {
		e.StatusIn = StatusInDraft
		return nil
	}
	if forward {
		if currentIndex < len(statusInOrder)-1 {
			e.StatusIn = statusInOrder[currentIndex+1]
			return nil
		}
		return errors.New("already at the final inbound status")
	} else {
		if currentIndex > 0 {
			e.StatusIn = statusInOrder[currentIndex-1]
			return nil
		}
		return errors.New("already at the initial inbound status")
	}
}

func (e *InventoryItemEntry) TransitionStatusOut(forward bool) error {
	if e.IsLocked() {
		return errors.New("cannot transition status: entry is in a terminal state (Delivered/Cancelled)")
	}
	currentIndex := -1
	for i, s := range statusOutOrder {
		if s == e.StatusOut {
			currentIndex = i
			break
		}
	}
	if currentIndex == -1 {
		e.StatusOut = StatusOutDraft
		return nil
	}
	if forward {
		if currentIndex < len(statusOutOrder)-1 {
			e.StatusOut = statusOutOrder[currentIndex+1]
			return nil
		}
		return errors.New("already at the final outbound status")
	} else {
		if currentIndex > 0 {
			e.StatusOut = statusOutOrder[currentIndex-1]
			return nil
		}
		return errors.New("already at the initial outbound status")
	}
}

func (e *InventoryItemEntry) CancelEntry(isInbound bool) error {
	if e.IsLocked() {
		return errors.New("cannot cancel: entry is already finalized")
	}
	if isInbound {
		e.StatusIn = StatusInCancelled
	} else {
		e.StatusOut = StatusOutCancelled
	}
	return nil
}

func (e *InventoryItemEntry) MarkAsMissing() error {
	if e.IsLocked() {
		return errors.New("cannot mark as missing: entry is already in a terminal state")
	}
	e.StatusIn = StatusInMissing
	return nil
}

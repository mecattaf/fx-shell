package gops_handler

import (
	"context"
	"strings"

	"github.com/AvengeMedia/dgop/gops"
	"github.com/AvengeMedia/dgop/internal/log"
	"github.com/AvengeMedia/dgop/models"
	"github.com/danielgtaylor/huma/v2"
)

type MetaInput struct {
	Modules        []string        `query:"modules" required:"true" example:"cpu,memory,network"`
	SortBy         gops.ProcSortBy `query:"sort_by" default:"cpu"`
	Limit          int             `query:"limit" default:"0"`
	DisableProcCPU bool            `query:"disable_proc_cpu" default:"false"`

	// Module-specific parameters
	GPUPciIds      []string `query:"gpu_pci_ids" example:"10de:2684,1002:164e" doc:"PCI IDs for GPU temperatures (when gpu module is requested)"`
	CPUCursor      string   `query:"cpu_cursor" doc:"CPU cursor from previous request"`
	ProcCursor     string   `query:"proc_cursor" doc:"Process cursor from previous request"`
	NetRateCursor  string   `query:"net_rate_cursor" doc:"Network rate cursor from previous request"`
	DiskRateCursor string   `query:"disk_rate_cursor" doc:"Disk rate cursor from previous request"`
}

type MetaResponse struct {
	Body *models.MetaInfo
}

type ModulesResponse struct {
	Body *models.ModulesInfo
}

// GET /meta
func (self *HandlerGroup) Meta(ctx context.Context, input *MetaInput) (*MetaResponse, error) {
	// Parse modules if it's a single comma-separated string
	var modules []string
	if len(input.Modules) == 1 && strings.Contains(input.Modules[0], ",") {
		modules = strings.Split(input.Modules[0], ",")
		// Trim whitespace
		for i, module := range modules {
			modules[i] = strings.TrimSpace(module)
		}
	} else {
		modules = input.Modules
	}

	params := gops.MetaParams{
		SortBy:         input.SortBy,
		ProcLimit:      input.Limit,
		EnableCPU:      !input.DisableProcCPU,
		GPUPciIds:      input.GPUPciIds,
		CPUCursor:      input.CPUCursor,
		ProcCursor:     input.ProcCursor,
		NetRateCursor:  input.NetRateCursor,
		DiskRateCursor: input.DiskRateCursor,
	}

	metaInfo, err := self.srv.Gops.GetMeta(modules, params)
	if err != nil {
		log.Error("Error getting meta info")
		return nil, huma.Error400BadRequest(err.Error())
	}

	return &MetaResponse{Body: metaInfo}, nil
}

// GET /modules
func (self *HandlerGroup) Modules(ctx context.Context, input *struct{}) (*ModulesResponse, error) {
	modulesInfo, err := self.srv.Gops.GetModules()
	if err != nil {
		log.Error("Error getting modules info")
		return nil, huma.Error500InternalServerError("Unable to retrieve modules info")
	}

	return &ModulesResponse{Body: modulesInfo}, nil
}

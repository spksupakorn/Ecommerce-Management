package servers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/spksupakorn/Ecommerce-Management/modules/middlewares/middlewaresHandlers"
	"github.com/spksupakorn/Ecommerce-Management/modules/middlewares/middlewaresRepositories"
	"github.com/spksupakorn/Ecommerce-Management/modules/middlewares/middlewaresUsecases"
	"github.com/spksupakorn/Ecommerce-Management/modules/monitor/monitorHandlers"
)

type IModuleFactory interface {
	MonitorModule()
}

type moduleFactory struct {
	r   fiber.Router
	s   *server
	mid middlewaresHandlers.IMiddlewaresHandler
}

func InitModule(r fiber.Router, s *server, mid middlewaresHandlers.IMiddlewaresHandler) IModuleFactory {
	return &moduleFactory{
		r:   r,
		s:   s,
		mid: mid,
	}
}

func InitMiddlewares(s *server) middlewaresHandlers.IMiddlewaresHandler {
	repository := middlewaresRepositories.MiddlewaresRepository((s.db))
	usecase := middlewaresUsecases.MiddlewaresUsecase(repository)
	return middlewaresHandlers.MiddlewaresHandler(s.cfg, usecase)
}

func (m *moduleFactory) MonitorModule() {
	handler := monitorHandlers.MonitorHandler(m.s.cfg)

	m.r.Get("/", handler.HealthCheck)
}

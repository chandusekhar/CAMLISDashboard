using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Practices.CompositeWeb;
using Microsoft.Practices.CompositeWeb.Interfaces;
using Microsoft.Practices.CompositeWeb.Services;
using Microsoft.Practices.CompositeWeb.Configuration;
using Microsoft.Practices.CompositeWeb.EnterpriseLibrary.Services;
using CHAI.LISDashboard.Services;

namespace CHAI.LISDashboard.Modules.ViralLoad
{
    public class ViralLoadModuleInitializer : ModuleInitializer
    {
        public override void Load(CompositionContainer container)
        {
            base.Load(container);

            AddGlobalServices(container.Parent.Services);
            AddModuleServices(container.Services);
        }

        protected virtual void AddGlobalServices(IServiceCollection globalServices)
        {
            // TODO: add a service that will be visible to any module
        }

        protected virtual void AddModuleServices(IServiceCollection moduleServices)
        {
        }


    }
}

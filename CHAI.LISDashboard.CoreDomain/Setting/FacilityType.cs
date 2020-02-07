using System;
using System.Collections.Generic;
using System.Security.Principal;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

using CHAI.LISDashboard.Enums;
using CHAI.LISDashboard.CoreDomain;

namespace CHAI.LISDashboard.CoreDomain.Setting
{
    public partial class FacilityType:IEntity
    {
        public int Id { get; set; }
        public string FacilityTypeName { get; set; }
        public string Description { get; set; }
        public string FacilityType2 { get; set; }
    }
}

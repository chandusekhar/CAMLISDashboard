using System;
using System.Collections.Generic;

namespace SKDH.AssociationManagment.DataAccess.Models
{
    public partial class Customer
    {
        public int Id { get; set; }
        public string CustomerName { get; set; }
        public string PhoneNo { get; set; }
        public string Address { get; set; }
    }
}

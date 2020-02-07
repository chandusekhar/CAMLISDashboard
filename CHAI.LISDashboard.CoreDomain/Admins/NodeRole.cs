
using System;
using CHAI.LISDashboard.CoreDomain.Users;

namespace CHAI.LISDashboard.CoreDomain.Admins
{
    public class NodeRole : IEntity
    {
        public int Id { get; set; }
        public bool ViewAllowed { get; set; }
        public bool EditAllowed { get; set; }

        public virtual Node Node { get; set; }
        public virtual Role Role { get; set; }
    }
}

﻿using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Practices.ObjectBuilder;
using Microsoft.Practices.CompositeWeb;
using CHAI.LISDashboard.CoreDomain;
using CHAI.LISDashboard.CoreDomain.Users;

namespace CHAI.LISDashboard.Modules.Shell.Views
{
    public class UserLoginPresenter : Presenter<IUserLoginView>
    {
        private ShellController _controller;

        public UserLoginPresenter()
        {
        }

        public override void OnViewLoaded()
        {
            // TODO: Implement code that will be executed every time the view loads
        }

        public override void OnViewInitialized()
        {
            // TODO: Implement code that will be executed the first time the view loads
        }

        [CreateNew]
        public ShellController Controller
        {
            get
            {
                return _controller;
            }
            set
            {
                if (value == null)
                    throw new ArgumentNullException("value");

                this._controller = value;
            }
        }

        public bool AuthenticateUser()
        {
            var v = Controller.GetCurrentContext();
            AuthenticationModule am = (AuthenticationModule)Controller.GetCurrentContext().ApplicationInstance.Modules["AuthenticationModule"];
           // AuthenticationModule am = new AuthenticationModule();
            if (View.GetUserName.Trim().Length > 0 && View.GetPassword.Trim().Length > 0)
            {
                try
                {
                    if (am.AuthenticateUser(View.GetUserName, View.GetPassword, View.PersistLogin))
                        return true;
                    else
                        return false;
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message);
                }
            }
            else
            {
                throw new Exception("USERNAMEPASSWORDMISSING");
            }
        }
        public void Logout()
        {
            AuthenticationModule am = (AuthenticationModule)Controller.GetCurrentContext().ApplicationInstance.Modules["AuthenticationModule"];
            am.Logout();
        }

        public AppUser CurrentUser
        {
            get { return Controller.GetCurrentUser(); }
        }

        //Added by ZaySoe on 11_Jan_2019
        public AppUser GetUser(int userid)
        {
            return Controller.GetUser(userid);
        }

        public bool IsAuthenticated
        {
            get
            {
                return Controller.UserIsAuthenticated;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public void RedirectToRowUrl()
        {
            Controller.Navigate(Controller.GetCurrentContext().Request.RawUrl);
        }

    }
}





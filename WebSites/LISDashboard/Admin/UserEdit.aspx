﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserEdit.aspx.cs" Inherits="CHAI.LISDashboard.Modules.Admin.Views.UserEdit"
    Title="UserEdit" MasterPageFile="~/Shared/AdminMaster.master" %>

<%@ MasterType TypeName="CHAI.LISDashboard.Modules.Shell.BaseMaster" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="content" ContentPlaceHolderID="DefaultContent" runat="Server">
    <script type="text/javascript" src="../js/libs/jquery-2.0.2.min.js"></script>
      <script type="text/javascript">

     function postBackByObject()
     {
         var o = window.event.srcElement;
         if (o.tagName == "INPUT" && o.type == "checkbox")
        {
           __doPostBack("","");
        } 
     }
        
    

   </script>
      <script type="text/javascript">
             $(document).ready(function () {
                var tab = document.getElementById('<%= hidTAB.ClientID%>').value;
                 $('#myTab1 a[href="' + tab + '"]').tab('show');
            });
    </script>
    <asp:HiddenField ID="hidTAB" runat="server" Value="#s1" />
    <div class="jarviswidget" id="wid-id-8" data-widget-editbutton="false" data-widget-custombutton="false">
        <header>
            <span class="widget-icon"><i class="fa fa-edit"></i></span>
            <h2>User</h2>
        </header>
        <div>
            <div class="jarviswidget-editbox"></div>
            <div class="widget-body no-padding">
                <div class="smart-form">
                    <fieldset>
                        <div class="row">
                            <section class="col col-6">

                                <label class="label">Username</label>
                                <label class="input">
                                    <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername"
                                        Display="Dynamic" ErrorMessage="User name is required" CssClass="validator"
                                        SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    <cc1:ValidatorCalloutExtender ID="rfvUsername_ValidatorCalloutExtender"
                                        runat="server" Enabled="True" TargetControlID="rfvUsername" Width="300px">
                                    </cc1:ValidatorCalloutExtender>
                                    <asp:Label ID="lblUsername" runat="server" Visible="False"></asp:Label></label>
                            </section>
                        </div>
                        <div class="row">
                            <section class="col col-6">
                                <label class="label">First name</label>
                                <label class="input">

                                    <asp:TextBox ID="txtFirstname" runat="server"></asp:TextBox></label>
                            </section>
                        </div>
                        <div class="row">
                            <section class="col col-6">
                                <label class="label">Last name</label>
                                <label class="input">
                                    <asp:TextBox ID="txtLastname" runat="server"></asp:TextBox></label>
                            </section>
                        </div>
                       
                        <div class="row">
                            <section class="col col-6">
                                <label class="label">Email</label>
                                <label class="input">


                                    <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" CssClass="validator" ControlToValidate="txtEmail"
                                        Display="Dynamic" ErrorMessage="Invalid Email Address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                        SetFocusOnError="True"></asp:RegularExpressionValidator>
                                    <cc1:ValidatorCalloutExtender ID="RegularExpressionValidator1_ValidatorCalloutExtender"
                                        runat="server" Enabled="True" TargetControlID="RegularExpressionValidator1" Width="300px">
                                    </cc1:ValidatorCalloutExtender>
                                    &nbsp;<asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                        Display="Dynamic" ErrorMessage="Email is required"
                                        SetFocusOnError="True"></asp:RequiredFieldValidator>
                                    <cc1:ValidatorCalloutExtender ID="rfvEmail_ValidatorCalloutExtender"
                                        runat="server" Enabled="True" TargetControlID="rfvEmail" Width="300px">
                                    </cc1:ValidatorCalloutExtender>
                                </label>
                            </section>
                        </div>
                        <div class="row">
                            <section class="col col-6">
                                    <asp:CheckBox ID="chkActive" runat="server" Text="Is Active" Checked="True"></asp:CheckBox>
                            </section>
                        </div>
                        <div class="row">
                            <section class="col col-6">
                                <label class="label">Password</label>
                                <label class="input">


                                    <asp:TextBox ID="txtPassword1" type="password" runat="server"></asp:TextBox></label>
                            </section>
                        </div>
                        <div class="row">
                            <section class="col col-6">
                                <label class="label">Confirm password</label>
                                <label class="input">



                                    <asp:TextBox ID="txtPassword2" type="password" runat="server"></asp:TextBox>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtPassword1"
                                        ControlToValidate="txtPassword2" Display="Dynamic" ErrorMessage="The password you typed donot match. Please retype the password"
                                        SetFocusOnError="True"></asp:CompareValidator>
                                    <cc1:ValidatorCalloutExtender ID="CompareValidator1_ValidatorCalloutExtender" runat="server"
                                        Enabled="True" TargetControlID="CompareValidator1" Width="300px">
                                    </cc1:ValidatorCalloutExtender>
                                </label>
                            </section>
                        </div>
                    </fieldset>
                   
                    <ul id="myTab1" class="nav nav-tabs bordered">
											<li class="">
												<a href="#s1" data-toggle="tab">Roles</a>
											</li>
											<li class="">
												<a href="#s2" data-toggle="tab">User Location</a>
											</li>
											
										</ul>
                     <div id="myTabContent1" class="tab-content padding-10">
											<div class="tab-pane fade active in" id="s1">
												<div class="table-responsive">

                        <table class="table table-striped table-bordered table-hover">

                            <asp:Repeater ID="rptRoles" runat="server">
                                <HeaderTemplate>
                                    <tr>
                                        <th>Role
                                        </th>
                                        <th></th>
                                    </tr>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%# DataBinder.Eval(Container.DataItem, "Name") %>
                                        </td>
                                        <td style="text-align: center">
                                            <asp:CheckBox ID="chkRole" runat="server"></asp:CheckBox>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </div>
											</div>
                                            
											<div class="tab-pane fade " id="s2">                                                                                                                                               
                                                <ul id="myTab2" class="nav nav-tabs bordered">
														<li class="active">
															<a data-toggle="tab" href="#fac">National/Regional/Facility User</a>
														</li>
														<li class="">
															<a data-toggle="tab" href="#lab">Lab User</a>
														</li>
														
												</ul>
                                                <div id="myTabContent2" class="tab-content padding-10">                                                   
                                                    <div class="tab-pane fade active in" id="fac">
                                                        <asp:UpdatePanel runat="server" id="UpdatePanel1" updatemode="Conditional">           
                                                        <ContentTemplate>
                                                            <asp:TreeView ID="TreeView1" runat="server" ShowCheckBoxes="All" ExpandDepth="0" OnTreeNodeCheckChanged="TreeView1_TreeNodeCheckChanged"></asp:TreeView>
                                                        </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                     </div>
                                                    <div class="tab-pane fade " id="lab">
                                                        <asp:TreeView ID="TreeView2" runat="server" ShowCheckBoxes="All" ExpandDepth="0" OnTreeNodeCheckChanged="TreeView2_TreeNodeCheckChanged"></asp:TreeView>
                                                    </div>
                                                </div>                                                                                                  
											  
                                            </div>
										
										</div>
                                
                    <footer>
                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" class="btn btn-primary"></asp:Button>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="False"
                            OnClick="btnCancel_Click" class="btn btn-primary"></asp:Button>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click" Visible="False" class="btn btn-primary"></asp:Button>
                    </footer>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" />

    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/constructor.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
    <xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/controller/method-click-common.xsl" />


    <xsl:template match="screen">

        <xsl:apply-templates select="." mode="file-header">
            <xsl:with-param name="fileName"><xsl:value-of select="name"/>Controller.cs</xsl:with-param>
        </xsl:apply-templates>

        <xsl:text>using </xsl:text><xsl:value-of select="./viewmodel/package" /><xsl:text>;&#13;</xsl:text>
        <xsl:for-each select="./pages/page">
            <xsl:for-each select="./actions/action">
                <xsl:text>using </xsl:text><xsl:value-of select="./package" /><xsl:text>;&#13;</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:if test="./viewmodel/subvm/viewmodel/dataloader-impl/package">
            <xsl:text>using </xsl:text><xsl:value-of select="./viewmodel/subvm/viewmodel/dataloader-impl/package" /><xsl:text>;&#13;</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="." mode="declare-impl-imports" />
        <xsl:call-template name="controller-imports"/>

        <xsl:text>&#13;&#13;</xsl:text>

        <xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
        <xsl:text>&#13;&#13;/// &lt;summary&gt;&#13;</xsl:text>
        <xsl:text>/// Class </xsl:text><xsl:value-of select="./name" /><xsl:text>Controller.&#13;</xsl:text>
        <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
        <xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
        <xsl:text>public class </xsl:text><xsl:value-of select="./name" /><xsl:text>Controller : MDKScreenController</xsl:text>
        <xsl:text>{</xsl:text>

        <!--=================-->
        <!--Region Properties-->
        <!--=================-->
        <xsl:text>&#13;#region Properties&#13;</xsl:text>

        <xsl:text>private SynchronizationContext _context;&#13;</xsl:text>

        <xsl:for-each select="./pages/page">
            <xsl:apply-templates select="." mode="create-pages-properties" />
        </xsl:for-each>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <!--==================-->
        <!--Region Constructor-->
        <!--==================-->
        <xsl:text>&#13;&#13;#region Constructor&#13;</xsl:text>

        <xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text>Controller() {&#13;</xsl:text>

        <xsl:text>this.ViewModel = (</xsl:text><xsl:value-of select="vm"/><xsl:text>) ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="vm"/><xsl:text>&gt;();&#13;</xsl:text>

        <xsl:text>_context = SynchronizationContext.Current;&#13;</xsl:text>

        <xsl:for-each select="./pages/page">
            <xsl:apply-templates select="." mode="create-pages-constructor" />
        </xsl:for-each>

        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">constructor</xsl:with-param>
            <xsl:with-param name="defaultSource"></xsl:with-param>
        </xsl:call-template>

        <xsl:for-each select="viewmodel/navigations/navigation[@type='NAVIGATION']">
            <xsl:text>((</xsl:text><xsl:value-of select="../../name"/><xsl:text>) ViewModel).</xsl:text>
            <xsl:value-of select="target/name"/><xsl:text>NavigationRequest += </xsl:text>
            <xsl:value-of select="target/name"/><xsl:text>Navigation;&#13;</xsl:text>
        </xsl:for-each>

        <xsl:for-each select="pages/page">
            <xsl:for-each select="navigations/navigation">
                <xsl:if test="@type='NAVIGATION_DETAIL'">
                    <xsl:text>((</xsl:text><xsl:value-of select="../../viewmodel/name"/><xsl:text>)</xsl:text>
                        <xsl:text>((</xsl:text><xsl:value-of select="../../../../vm"/><xsl:text>) ViewModel).</xsl:text>
                    <xsl:value-of select="../../viewmodel/name"/><xsl:text>).</xsl:text>
                    <xsl:value-of select="sourcePage/name"/><xsl:text>NavigationDetailRequest += </xsl:text>
                    <xsl:value-of select="target/name"/><xsl:text>Navigation;&#13;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:text>}&#13;&#13;</xsl:text>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <!--==============-->
        <!--Region Methods-->
        <!--==============-->
        <xsl:text>&#13;#region Methods&#13;</xsl:text>

        <xsl:text>&#13;public override void onNavigatedTo(object parameter)&#13;{&#13;</xsl:text>

        <xsl:for-each select="./pages/page">
            <xsl:apply-templates select="." mode="create-pages-onreload" />
        </xsl:for-each>

        <xsl:text>}&#13;&#13;</xsl:text>

        <xsl:for-each select="viewmodel/navigations/navigation">
            <xsl:text>public void </xsl:text><xsl:value-of select="target/name"/><xsl:text>Navigation(object sender, Object parameter)&#13;{&#13;</xsl:text>
            <xsl:text>IMDKNavigationService navigationService = ClassLoader.GetInstance().GetBean&lt;IMDKNavigationService&gt;();&#13;</xsl:text>
            <xsl:text>navigationService.Navigate("</xsl:text><xsl:value-of select="target/name"/><xsl:text>Controller",parameter);&#13;}&#13;&#13;</xsl:text>
        </xsl:for-each>

        <xsl:for-each select="pages/page">
            <xsl:for-each select="navigations/navigation">
                <xsl:if test="@type='NAVIGATION_DETAIL'">
                    <xsl:text>public void </xsl:text><xsl:value-of select="target/name"/><xsl:text>Navigation(object sender, Object parameter)&#13;{&#13;</xsl:text>
                    <xsl:text>IMDKNavigationService navigationService = ClassLoader.GetInstance().GetBean&lt;IMDKNavigationService&gt;();&#13;</xsl:text>
                    <xsl:text>IViewModel vm = parameter as IViewModel;&#13;</xsl:text>
                    <xsl:text>navigationService.Navigate("</xsl:text><xsl:value-of select="target/name"/><xsl:text>Controller",vm.ID_id);&#13;}&#13;&#13;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>

        <xsl:for-each select="./pages/page">
            <xsl:apply-templates select="." mode="create-pages-methods" />
        </xsl:for-each>

        <xsl:text>&#13;#endregion&#13;</xsl:text>

        <xsl:text>}&#13;</xsl:text>
        <xsl:text>}&#13;</xsl:text>

    </xsl:template>

    <xsl:template match="page" mode="create-pages-constructor">
        <xsl:text>_</xsl:text><xsl:value-of select="name"/><xsl:text>selectedId = 1;&#13;</xsl:text>
        <xsl:value-of select="viewmodel/dataloader-impl/name"/><xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name"/><xsl:text>&gt;();&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="page" mode="create-pages-properties">
        <xsl:text>&#13;private long _</xsl:text><xsl:value-of select="name"/><xsl:text>selectedId;&#13;</xsl:text>
        <xsl:text>public </xsl:text>
        <xsl:choose>
            <xsl:when test="viewmodel/dataloader-impl/dataloader-interface/name">
                <xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>AbstractDataLoader&lt;IMIdentifiable&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text><xsl:value-of select="name"/><xsl:text>Loader&#13;{&#13;</xsl:text>
        <xsl:text>get;&#13;</xsl:text>
        <xsl:text>set;&#13;}&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="page" mode="create-pages-methods">
        <xsl:text>&#13;#region </xsl:text><xsl:value-of select="name"/><xsl:text>&#13;</xsl:text>

        <!--Do on reload panel data loader-->
        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">doOnReload<xsl:value-of select="name"/>DataLoader-method</xsl:with-param>
            <xsl:with-param name="defaultSource">
                <xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">//</xsl:if>
                <xsl:text>[ListenerFromDataLoader(typeof(</xsl:text><xsl:value-of
                    select="viewmodel/dataloader-impl/name" /><xsl:text>))]&#13;</xsl:text>
                <xsl:text>public void DoOnReload</xsl:text><xsl:value-of select="name"/><xsl:text>DataLoader()</xsl:text>
                <xsl:text>{</xsl:text>
                <xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">/*</xsl:if>
                <xsl:text>_context.Post(delegate{&#13;</xsl:text>
                <xsl:text>((</xsl:text><xsl:value-of select="../../vm"/><xsl:text>)ViewModel).</xsl:text><xsl:value-of select="viewmodel/name"/>
                <xsl:text>.UpdateFromDataLoader(</xsl:text><xsl:value-of select="name"/><xsl:text>Loader);</xsl:text>
                <xsl:text>&#13;}, null);&#13;</xsl:text>
                <xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">*/</xsl:if>
                <xsl:text>}&#13;</xsl:text>
            </xsl:with-param>
        </xsl:call-template>

        <!--Reload panel data-->
        <xsl:text>&#13;public void reload</xsl:text><xsl:value-of select="name"/><xsl:text>Data()</xsl:text>
		<xsl:text>&#13;{</xsl:text>
		<xsl:choose>
			<xsl:when test="viewmodel/dataloader-impl/dataloader-interface/type = 'LIST'">
				this.loadListData(<xsl:value-of select="name"/>Loader);
			</xsl:when>
			<xsl:otherwise>
				this.loadData(<xsl:value-of select="name"/>Loader, _<xsl:value-of select="name"/>selectedId);
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#13;}&#13;</xsl:text>

        <!--panel CUDActionArgs-->
        <xsl:if test="viewmodel/type/is-list = 'false'">
			<xsl:text>	&#13;public CUDActionArgs Get</xsl:text><xsl:value-of select="name"/><xsl:text>CUDActionArgs()</xsl:text>
			<xsl:text>	{</xsl:text>
			<xsl:text>	return this.GetCUDActionArgs(</xsl:text><xsl:value-of select="name"/><xsl:text>Loader, </xsl:text>
            <xsl:text>((</xsl:text><xsl:value-of select="../../vm"/><xsl:text>)ViewModel).</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text>);&#13;</xsl:text>
			<xsl:text>	}&#13;</xsl:text>
		</xsl:if>

        <!--panel save data-->
        <xsl:if test="actions/action[action-type = 'SAVEDETAIL']">
            <xsl:if test="viewmodel/dataloader-impl/dataloader-interface/type = 'SINGLE' and in-workspace = 'false' and in-multi-panel = 'false' and layout/buttons/button[@type='SAVE']">
                <xsl:text>public void Save</xsl:text><xsl:value-of select="name"/><xsl:text>()</xsl:text>
                <xsl:text>{&#13;</xsl:text>
                <xsl:if test="not(/dialog)">
                    <xsl:text>&#13;</xsl:text>
                    <xsl:text>Object[] tab = this.PrepareSave</xsl:text><xsl:value-of select="name"/><xsl:text>();</xsl:text>
                    <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction((Type)tab[0], this, (CUDActionArgs)tab[1]);</xsl:text>
                    <xsl:if test="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']">
                        <xsl:value-of
                                select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized" /><xsl:text>_ReloadEvent();</xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="/dialog">
                    <!-- 				SavePeopleSearchScreenSearchDialogActionArgs saveActionArgs = new SavePeopleSearchScreenSearchDialogActionArgs(); -->
                    <!-- 		saveActionArgs.viewModel = ViewModel; -->
                    <!--         saveActionArgs.dataLoader = Loader; -->
                    <!-- 		ClassLoader.GetInstance().GetBean<IMFController>().LaunchAction(typeof(SavePeopleSearchScreenSearchDialogActionArgs), this, saveActionArgs); -->
                </xsl:if>
                <xsl:text>}&#13;&#13;</xsl:text>
            </xsl:if>

            <xsl:text>public object[] PrepareSave</xsl:text><xsl:value-of select="name"/><xsl:text>()</xsl:text>
            <xsl:text>{</xsl:text>
            <xsl:text>Object[] tab = new Object[2];</xsl:text>
            <xsl:text>tab[0] = typeof(</xsl:text><xsl:value-of
                select="actions/action[action-type = 'SAVEDETAIL']/name" /><xsl:text>);</xsl:text>
            <xsl:text>tab[1] = Get</xsl:text><xsl:value-of select="name"/><xsl:text>CUDActionArgs();</xsl:text>
            <xsl:text>return tab;</xsl:text>
            <xsl:text>}&#13;&#13;</xsl:text>
        </xsl:if>

        <!--panel delete-->
        <xsl:if test="actions/action[action-type = 'DELETEDETAIL']">
            <xsl:text>public void Delete</xsl:text><xsl:value-of select="name"/><xsl:text>()</xsl:text>
            <xsl:text>{&#13;</xsl:text>
            <xsl:if test="not(/dialog)">
                <xsl:text>&#13;</xsl:text>
                <xsl:text>Object[] tab = this.PrepareDelete</xsl:text><xsl:value-of select="name"/><xsl:text>();</xsl:text>
                <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction((Type)tab[0], this, (CUDActionArgs)tab[1]);</xsl:text>
                <xsl:if test="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']">
                    <xsl:value-of
                            select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized" /><xsl:text>_ReloadEvent();</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="/dialog">
                <!-- 				SavePeopleSearchScreenSearchDialogActionArgs saveActionArgs = new SavePeopleSearchScreenSearchDialogActionArgs(); -->
                <!-- 		saveActionArgs.viewModel = ViewModel; -->
                <!--         saveActionArgs.dataLoader = Loader; -->
                <!-- 		ClassLoader.GetInstance().GetBean<IMFController>().LaunchAction(typeof(SavePeopleSearchScreenSearchDialogActionArgs), this, saveActionArgs); -->
            </xsl:if>
            <xsl:text>}&#13;&#13;</xsl:text>

            <xsl:text>public object[] PrepareDelete</xsl:text><xsl:value-of select="name"/><xsl:text>()</xsl:text>
            <xsl:text>{</xsl:text>
            <xsl:text>Object[] tab = new Object[2];</xsl:text>
            <xsl:text>tab[0] = typeof(</xsl:text><xsl:value-of
                select="actions/action[action-type = 'DELETEDETAIL']/name" /><xsl:text>);</xsl:text>
            <xsl:text>tab[1] = Get</xsl:text><xsl:value-of select="name"/><xsl:text>CUDActionArgs();</xsl:text>
            <xsl:text>return tab;</xsl:text>
            <xsl:text>}&#13;&#13;</xsl:text>
        </xsl:if>

        <xsl:apply-templates select="layout/buttons/button" mode="method-click-listener-impl" />

        <xsl:if test="search-template">
            <xsl:call-template name="SearchClickMethod" />
        </xsl:if>

        <xsl:call-template name="pannel-chained_action">
            <xsl:with-param name="panelName"><xsl:value-of select="name"/></xsl:with-param>
        </xsl:call-template>

        <xsl:apply-templates select="navigationsV2/navigationV2" mode="create-event" >
            <xsl:with-param name="panelName"><xsl:value-of select="name"/></xsl:with-param>
        </xsl:apply-templates>

        <xsl:apply-templates select="reverse-navigationsV2/navigationV2" mode="create-event" >
            <xsl:with-param name="panelName"><xsl:value-of select="name"/></xsl:with-param>
        </xsl:apply-templates>

        <xsl:apply-templates select="layout/visualfields/visualfield" mode="panel-fixedlist-delete-button-impl" />


        <!-- isDirty TODO
        <xsl:text>&#13;public Boolean Is</xsl:text><xsl:value-of select="name"/><xsl:text>Dirty()&#13;{&#13;</xsl:text>
        <xsl:text>return (((</xsl:text><xsl:value-of select="../../vm"/><xsl:text>)ViewModel).</xsl:text><xsl:value-of select="viewmodel/name"/><xsl:text>).IsDirty;&#13;}&#13;</xsl:text>
        -->

        <xsl:text>&#13;#endregion&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="page" mode="create-pages-onreload">

        <xsl:text>if (parameter != null) &#13;{&#13;</xsl:text>
        <xsl:text>_</xsl:text><xsl:value-of select="name"/><xsl:text>selectedId = (long) parameter;&#13;}&#13;</xsl:text>
        <xsl:text>reload</xsl:text><xsl:value-of select="name"/><xsl:text>Data();&#13;</xsl:text>
    </xsl:template>


    <xsl:template name="pannel-chained_action">
        <xsl:param name="panelName" />
        <xsl:if test="in-workspace = 'true' and in-multi-panel = 'true'">
            <xsl:if test="./chained-save='true'">
                <xsl:text>&#13;</xsl:text>
                <xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
                <xsl:text>	/// Listener on Success of SaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>&#13;</xsl:text>
                <xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
                <xsl:text>&#13;[MFOnActionAttribute(typeof(SaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
                <xsl:text>public void DoOnSaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>_Success(Object sender, ChainedActionArgs e)&#13;</xsl:text>
                <xsl:text>{&#13;</xsl:text>
                <xsl:if test="viewmodel/type/is-list = 'true'">
                    <xsl:text>&#13;</xsl:text>
                    <xsl:text> this.loadListData(</xsl:text><xsl:value-of select="$panelName"/><xsl:text>Loader);&#13;</xsl:text>
                </xsl:if>
                <xsl:call-template name="non-generated-bloc">
                    <xsl:with-param name="blocId">
                        <xsl:text>SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference" />-method</xsl:with-param>
                    <xsl:with-param name="defaultSource"></xsl:with-param>
                </xsl:call-template>
                <xsl:text>}&#13;&#13;</xsl:text>

                <xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
                <xsl:text>	/// Listener on Failed of SaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>&#13;</xsl:text>
                <xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
                <xsl:text>&#13;[MFOnActionAttribute(typeof(SaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
                <xsl:text>public void DoOnSaveChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>_Failed(Object sender, ChainedActionArgs e)&#13;</xsl:text>
                <xsl:text>{&#13;</xsl:text>
                <xsl:call-template name="non-generated-bloc">
                    <xsl:with-param name="blocId">
                        <xsl:text>SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference" />-method</xsl:with-param>
                    <xsl:with-param name="defaultSource"></xsl:with-param>
                </xsl:call-template>
                <xsl:text>}&#13;</xsl:text>
            </xsl:if>

            <xsl:if test="./chained-delete='true'">
                <xsl:text>&#13;</xsl:text>
                <xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
                <xsl:text>	/// Listener on Success of DeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>&#13;</xsl:text>
                <xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="e">Out parameter of the delete action&lt;/param&gt;</xsl:text>
                <xsl:text>&#13;[MFOnActionAttribute(typeof(DeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
                <xsl:text>public void DoOnDeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>_Success(Object sender, ChainedActionArgs e)&#13;</xsl:text>
                <xsl:text>{&#13;</xsl:text>
                <xsl:if test="viewmodel/type/is-list = 'true'">
                    <xsl:text>&#13;</xsl:text>
                    <xsl:text> this.loadListData(</xsl:text><xsl:value-of select="$panelName"/><xsl:text>Loader);&#13;</xsl:text>
                </xsl:if>
                <xsl:call-template name="non-generated-bloc">
                    <xsl:with-param name="blocId">
                        <xsl:text>DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference" />-method</xsl:with-param>
                    <xsl:with-param name="defaultSource"></xsl:with-param>
                </xsl:call-template>
                <xsl:text>}&#13;&#13;</xsl:text>
                <xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
                <xsl:text>	/// Listener on Failed of DeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>&#13;</xsl:text>
                <xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
                <xsl:text>	/// &lt;param name="e">Out parameter of the delete action&lt;/param&gt;</xsl:text>
                <xsl:text>&#13;[MFOnActionAttribute(typeof(DeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
                <xsl:text>public void DoOnDeleteChained</xsl:text><xsl:value-of
                    select="viewmodel/first-parent-reference" /><xsl:text>_Failed(Object sender, ChainedActionArgs e)&#13;</xsl:text>
                <xsl:text>{&#13;</xsl:text>
                <xsl:call-template name="non-generated-bloc">
                    <xsl:with-param name="blocId">
                        <xsl:text>DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference" />-method</xsl:with-param>
                    <xsl:with-param name="defaultSource"></xsl:with-param>
                </xsl:call-template>
                <xsl:text>}&#13;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event">
        <xsl:param name="panelName" />
        <xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized" /><xsl:text>_SelectionChangedEvent))]&#13;</xsl:text>
        <xsl:text>public void DoOn</xsl:text><xsl:value-of select="$panelName"/><xsl:text>ItemSelected(object sender, </xsl:text><xsl:value-of
            select="source/component-name-capitalized" /><xsl:text>_SelectionChangedEvent e)</xsl:text>
        <xsl:text>{</xsl:text>
        <xsl:text>_</xsl:text><xsl:value-of select="$panelName"/><xsl:text>selectedId = e.Id;</xsl:text>
        <xsl:text>this.reload</xsl:text><xsl:value-of select="$panelName"/><xsl:text>Data();</xsl:text>
        <xsl:if test="../../parameters/parameter[@name = 'workspace-panel-type'] = 'detail' and ../../parameters/parameter[@name = 'grid-section-parameter'] = '1' and  ../../parameters/parameter[@name = 'grid-column-parameter']  = '1' ">
            <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, new MultiPanel_NavigateSelectedEvent(this));</xsl:text>
        </xsl:if>
        <xsl:text>&#13;</xsl:text>
        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">after-doOn<xsl:value-of select="$panelName"/>ItemSelected-method</xsl:with-param>
            <xsl:with-param name="defaultSource"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;&#13;</xsl:text>

        <xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized" /><xsl:text>_AddItemEvent))]&#13;</xsl:text>
        <xsl:text>public void DoOn</xsl:text><xsl:value-of select="$panelName"/><xsl:text>ItemAdd(object sender, </xsl:text><xsl:value-of
            select="source/component-name-capitalized" /><xsl:text>_AddItemEvent e)</xsl:text>
        <xsl:text>{</xsl:text>
        <xsl:text>_</xsl:text><xsl:value-of select="$panelName"/><xsl:text>selectedId = e.Id;</xsl:text>
        <xsl:text>this.reload</xsl:text><xsl:value-of select="$panelName"/><xsl:text>Data();</xsl:text>
        <xsl:if test="../../parameters/parameter[@name = 'workspace-panel-type'] = 'detail' and ../../parameters/parameter[@name = 'grid-section-parameter'] = '1' and  ../../parameters/parameter[@name = 'grid-column-parameter']  = '1' ">
            <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, new MultiPanel_NavigateAddEvent(this));</xsl:text>
        </xsl:if>
        <xsl:text>&#13;</xsl:text>
        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">after-doOn<xsl:value-of select="$panelName"/>ItemAdd-method</xsl:with-param>
            <xsl:with-param name="defaultSource"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;&#13;</xsl:text>

        <xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized" /><xsl:text>_DeleteItemEvent))]&#13;</xsl:text>
        <xsl:text>public void DoOn</xsl:text><xsl:value-of select="$panelName"/><xsl:text>ItemDelete(object sender, </xsl:text><xsl:value-of
            select="source/component-name-capitalized" /><xsl:text>_DeleteItemEvent e)</xsl:text>
        <xsl:text>{</xsl:text>
        <xsl:text>&#13;</xsl:text>
        <xsl:call-template name="non-generated-bloc">
            <xsl:with-param name="blocId">doOn<xsl:value-of select="$panelName"/>ItemDelete-method</xsl:with-param>
            <xsl:with-param name="defaultSource"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;&#13;</xsl:text>

        <xsl:text>public void </xsl:text><xsl:value-of select="source/component-name-capitalized" /><xsl:text>_ReloadEvent() {</xsl:text>
        <xsl:value-of select="source/component-name-capitalized" /><xsl:text>_ReloadEvent myevent = new </xsl:text>
        <xsl:value-of select="source/component-name-capitalized" /><xsl:text>_ReloadEvent();</xsl:text>
        <xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:text>&#13;</xsl:text>
    </xsl:template>

    <xsl:template match="visualfield" mode="panel-fixedlist-delete-button-impl">
        <xsl:if test="component='MFFixedList'">
            <xsl:text>&#13;/// </xsl:text>
            <xsl:value-of select="./property-name-c" />
            <xsl:text>button_Delete</xsl:text><xsl:value-of select="layout/prefix" /><xsl:text>_Click</xsl:text>
            <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
            <xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
            <xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
            <xsl:text>&#13;private void </xsl:text>
            <xsl:value-of select="./property-name-c" />
            <xsl:text>DeleteButton_Tapped(object sender, RoutedEventArgs e)</xsl:text>
            <xsl:text>&#13;{&#13;</xsl:text>
            <xsl:value-of select="./property-name-c" />
            <xsl:text>.DeleteItem_Tap(sender, e);&#13;</xsl:text>
            <xsl:call-template name="non-generated-bloc">
                <xsl:with-param name="blocId">after-DeleteButton_Tapped-method</xsl:with-param>
                <xsl:with-param name="defaultSource" />
            </xsl:call-template>
            <xsl:text>&#13;}</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="SearchClickMethod">
        <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
        <xsl:text>&#13;/// Launch an action of research on the list.</xsl:text>
        <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
        <xsl:text>&#13;/// &lt;param name="sender"&gt;SearchButton&lt;/param&gt;</xsl:text>
        <xsl:text>&#13;/// &lt;param name="e"&gt;Event&lt;/param&gt;</xsl:text>
        <xsl:text>&#13;private void </xsl:text><xsl:value-of
            select="./layout/visualfields/visualfield[component = 'MFList1D']/name" /><xsl:text>_SearchClick(object sender, RoutedEventArgs e)</xsl:text>
        <xsl:text>&#13;{</xsl:text>
        <xsl:text>&#13;// Create Save Action</xsl:text>
        <xsl:text>&#13;// Create Search Action</xsl:text>
        <xsl:text>&#13;SearchActionArgs search</xsl:text><xsl:value-of
            select="./viewmodel/dataloader-impl/dao-interface/dao/class/name" /><xsl:text>ActionArgs = new SearchActionArgs();</xsl:text>
        <xsl:text>&#13;search</xsl:text><xsl:value-of
            select="./viewmodel/dataloader-impl/dao-interface/dao/class/name" /><xsl:text>ActionArgs.dataLoader = Loader;</xsl:text>
        <xsl:text>&#13;search</xsl:text><xsl:value-of
            select="./viewmodel/dataloader-impl/dao-interface/dao/class/name" /><xsl:text>ActionArgs.viewModel = this.</xsl:text>
        <xsl:value-of select="./layout/visualfields/visualfield[component = 'MFList1D']/name" /><xsl:text>.SearchValue;</xsl:text>
        <xsl:text>&#13;// Launch Search Action</xsl:text>
        <xsl:text>&#13;ClassLoader.GetInstance().GetBean<![CDATA[<IMFController>]]>().LaunchAction(typeof(SearchAction), this, search</xsl:text><xsl:value-of
            select="./viewmodel/dataloader-impl/dao-interface/dao/class/name" /><xsl:text>ActionArgs);</xsl:text>
        <xsl:text>&#13;}</xsl:text>
    </xsl:template>
</xsl:stylesheet>
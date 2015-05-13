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

<xsl:output method="text"/>

<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/substring.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/replace-all.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/imports-common.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/method-click-common.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/cs-panel-list2d-methods.xsl"/>


<xsl:template match="page | dialog">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	<xsl:call-template name="panel-imports"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="declare-impl-imports"/>
	<xsl:if test="in-workspace = 'true' and in-multi-panel = 'true' and (./chained-delete='true' or ./chained-save='true')">
		<xsl:text>// Chained Action headers</xsl:text>
		<xsl:text>&#13;using </xsl:text><xsl:value-of select="master-package"/><xsl:text>.action.chainedactions;&#13;</xsl:text>
	</xsl:if>
	<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>public partial class </xsl:text><xsl:value-of select="name"/><xsl:text> : </xsl:text><xsl:call-template name="IsList" /><xsl:text> </xsl:text><xsl:value-of select="./implements/interface/@name" />
	<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
		<xsl:call-template name="add-interface-imfcomponentdictionary"/>
	</xsl:if>
	<xsl:text>{</xsl:text>
	<xsl:apply-templates select="navigations/navigation" mode="method-click-usercontrol-event" />
	<xsl:apply-templates select="reverse-navigationsV2/navigationV2" mode="method-click-usercontrol-event" />
	
	<xsl:text>private SynchronizationContext _context;</xsl:text> 
	<xsl:text>&#13;private IViewModelCreator _vmCreator;</xsl:text> 
	<xsl:text>&#13;private long _selectedId;</xsl:text> 
	<xsl:text>&#13;public </xsl:text> <xsl:value-of select="viewmodel-interface/name"/> <xsl:text>  ViewModel { get { return base.viewModel as </xsl:text><xsl:value-of select="viewmodel-interface/name"/><xsl:text>; } set { base.viewModel = value; } }&#13;</xsl:text>
	<xsl:if test="search-template">
	</xsl:if>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">loader</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:text>public </xsl:text>
			<xsl:choose>
				<xsl:when test="viewmodel/dataloader-impl/dataloader-interface/name">
					<xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>AbstractDataLoader&lt;IMIdentifiable&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> Loader&#13;{&#13;</xsl:text>
			<xsl:text>get&#13;{&#13;</xsl:text>
			<xsl:text>return base.loader as </xsl:text>
			<xsl:choose>
				<xsl:when test="viewmodel/dataloader-impl/dataloader-interface/name">
					<xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>AbstractDataLoader&lt;IMIdentifiable&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>;&#13;</xsl:text>
			<xsl:text>}&#13;set&#13;{&#13;</xsl:text>
			<xsl:text>base.loader = value;&#13;</xsl:text>
			<xsl:text>}&#13;}&#13;</xsl:text>
		</xsl:with-param>
	</xsl:call-template>
	
	<xsl:text>&#13;#region Constructors&#13;&#13;</xsl:text>
	<xsl:text>public </xsl:text><xsl:value-of select="name"/><xsl:text> ()</xsl:text>
	<xsl:text>{</xsl:text>
	<xsl:text>if(!IsInDesignMode()){</xsl:text>
	<xsl:text>_context = SynchronizationContext.Current;</xsl:text>
	<xsl:text>_vmCreator = ClassLoader.GetInstance().GetBean&lt;IViewModelCreator&gt;();</xsl:text>
	<xsl:text>ViewModel = _vmCreator.create</xsl:text><xsl:value-of select="viewmodel-interface/name"/><xsl:text>();</xsl:text>
	<xsl:if test="viewmodel/dataloader-impl/dataloader-interface/name">
		<xsl:text>Loader = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
		<xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name"/>
		<xsl:text>&gt;();</xsl:text>
	</xsl:if>
	<xsl:text>this.DataContext = ViewModel;</xsl:text>
	<xsl:text>_selectedId = 1;</xsl:text>
	<xsl:text>this.InitializeComponent();</xsl:text>
	<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
		<xsl:text>this.ComponentDictionary.Add(this.</xsl:text>
		<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name"/>
		<xsl:text>.Name , this.</xsl:text>
		<xsl:value-of select="layout/visualfields/visualfield[component = 'MFList2D']/name"/>
		<xsl:text>);</xsl:text>
	</xsl:if>
	<xsl:text>}&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">constructor</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:if test="not(viewmodel/dataloader-impl/dataloader-interface/name)">
				<xsl:text>// Add your dataloader here&#13;</xsl:text>
				<xsl:text>//Loader = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
				<xsl:value-of select="viewmodel/dataloader-impl/dataloader-interface/name"/>
				<xsl:text>&gt;();&#13;</xsl:text>
			</xsl:if>
		</xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
	
	<xsl:text>&#13;&#13;#endregion&#13;&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text><xsl:text></xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">doOnReloadDataLoader-method</xsl:with-param>
		<xsl:with-param name="defaultSource">
			<xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">//</xsl:if>
			<xsl:text>[ListenerFromDataLoader(typeof(</xsl:text><xsl:value-of select="viewmodel/dataloader-impl/name"/><xsl:text>))]&#13;</xsl:text>
			<xsl:text>public void DoOnReloadDataLoader()</xsl:text>
			<xsl:text>{</xsl:text>
			<xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">/*</xsl:if>
			<xsl:text>_context.Post(delegate{</xsl:text>
			<xsl:text>&#13;ViewModel.UpdateFromDataLoader(Loader);</xsl:text>
			<xsl:text>&#13;}, null);&#13;</xsl:text>
			<xsl:if test="not (viewmodel/dataloader-impl/dataloader-interface/name)">*/</xsl:if>
			<xsl:text>}&#13;</xsl:text>
		</xsl:with-param>
	</xsl:call-template>
	
	<xsl:if test="actions/action[action-type = 'SAVEDETAIL']">	
		<xsl:if test="viewmodel/dataloader-impl/dataloader-interface/type = 'SINGLE' and in-workspace = 'false' and in-multi-panel = 'false' and layout/buttons/button[@type='SAVE']">
			<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
			<xsl:text>public override void SavePanel()</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:if test="not(/dialog)">
				<xsl:text>&#13;</xsl:text>
				<xsl:text>Object[] tab = this.PrepareSavePanel();</xsl:text>
				<xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction((Type)tab[0], this, (CUDActionArgs)tab[1]);</xsl:text>
				<xsl:if test="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']">
					<xsl:value-of select="../../../reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_ReloadEvent();</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="/dialog">
		<!-- 				SavePeopleSearchScreenSearchDialogActionArgs saveActionArgs = new SavePeopleSearchScreenSearchDialogActionArgs(); -->
		<!-- 		saveActionArgs.viewModel = ViewModel; -->
		<!--         saveActionArgs.dataLoader = Loader; -->
		<!-- 		ClassLoader.GetInstance().GetBean<IMFController>().LaunchAction(typeof(SavePeopleSearchScreenSearchDialogActionArgs), this, saveActionArgs); -->
			</xsl:if>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
	
		<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	    <xsl:text>public override object[] PrepareSavePanel()</xsl:text>
	    <xsl:text>{</xsl:text>
	    <xsl:text>Object[] tab = new Object[2];</xsl:text>
	    <xsl:text>tab[0] = typeof(</xsl:text><xsl:value-of select="actions/action[action-type = 'SAVEDETAIL']/name"/><xsl:text>);</xsl:text>
	    <xsl:text>tab[1] = GetCUDActionArgs();</xsl:text>
	    <xsl:text>return tab;</xsl:text>
	    <xsl:text>}</xsl:text>
	</xsl:if>
	
	<xsl:if test="actions/action[action-type = 'DELETEDETAIL']">
		<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	    <xsl:text>public override object[] PrepareDeletePanel()</xsl:text>
	    <xsl:text>{</xsl:text>
	    <xsl:text>Object[] tab = new Object[2];</xsl:text>
	    <xsl:text>tab[0] = typeof(</xsl:text><xsl:value-of select="actions/action[action-type = 'DELETEDETAIL']/name"/><xsl:text>);</xsl:text>
	    <xsl:text>tab[1] = GetCUDActionArgs();</xsl:text>
	    <xsl:text>return tab;</xsl:text>
	    <xsl:text>}</xsl:text>
	</xsl:if>

	<xsl:apply-templates select="layout/buttons/button" mode="method-click-impl" />

	<xsl:text>&#13;/// &lt;inheritDoc/&gt;</xsl:text>
	<xsl:text>&#13;public override void reloadData()</xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:choose>
		<xsl:when test="viewmodel/dataloader-impl/dataloader-interface/type = 'LIST'">
		this.loadListData(Loader);
		</xsl:when>
		<xsl:otherwise>
		this.loadData(Loader, _selectedId);
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>&#13;}&#13;</xsl:text>
	
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;</xsl:text>
	<xsl:text>&#13; public Boolean IsToDisplay(</xsl:text><xsl:call-template name="IsList" /><xsl:text> uc)</xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:text>&#13; return this == uc;</xsl:text>
	<xsl:text>&#13;}</xsl:text>
	
	<xsl:if test="search-template">
		<xsl:call-template name="SearchClickMethod" />
	</xsl:if>
	
	<xsl:call-template name="pannel-chained_action" />
	
	<xsl:apply-templates select="navigationsV2/navigationV2" mode="create-event" />
	<xsl:apply-templates select="reverse-navigationsV2/navigationV2" mode="create-event" />
	<xsl:apply-templates select="." mode="create-action-error-method" />
	<xsl:apply-templates select="layout/visualfields/visualfield" mode="panel-fixedlist-delete-button-impl"/>
	
	<xsl:if test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
		<xsl:call-template name="add-list2d-methods"/>
	</xsl:if>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 

	<xsl:text>&#13;#endregion&#13;</xsl:text>	
	
	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>


<xsl:template name="pannel-chained_action">
 	<xsl:if test="in-workspace = 'true' and in-multi-panel = 'true'">
 		<xsl:if test="./chained-save='true'">
	 		<xsl:text>&#13;</xsl:text>
			<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
			<xsl:text>	/// Listener on Success of SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>&#13;</xsl:text>
			<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
			<xsl:text>&#13;[MFOnActionAttribute(typeof(SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
			<xsl:text>public void DoOnSaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>_Success(Object sender, ChainedActionArgs e)&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:if test="viewmodel/type/is-list = 'true'">
				<xsl:text>&#13;</xsl:text>
				<xsl:text> this.loadListData(Loader);&#13;</xsl:text>
			</xsl:if>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId"><xsl:text>SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/>-method</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
			<xsl:text>}&#13;&#13;</xsl:text>
			<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
			<xsl:text>	/// Listener on Failed of SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>&#13;</xsl:text>
			<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="e">Out parameter of the save action&lt;/param&gt;</xsl:text>
			<xsl:text>&#13;[MFOnActionAttribute(typeof(SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
			<xsl:text>public void DoOnSaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>_Failed(Object sender, ChainedActionArgs e)&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId"><xsl:text>SaveChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/>-method</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
		
		<xsl:if test="./chained-delete='true'">
			<xsl:text>&#13;</xsl:text>
			<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
			<xsl:text>	/// Listener on Success of DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>&#13;</xsl:text>
			<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="e">Out parameter of the delete action&lt;/param&gt;</xsl:text>
			<xsl:text>&#13;[MFOnActionAttribute(typeof(DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>), ActionLauncher.ActionResult.Success)]&#13;</xsl:text>
			<xsl:text>public void DoOnDeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>_Success(Object sender, ChainedActionArgs e)&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:if test="viewmodel/type/is-list = 'true'">
				<xsl:text>&#13;</xsl:text>
				<xsl:text> this.loadListData(Loader);&#13;</xsl:text>
			</xsl:if>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId"><xsl:text>DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/>-method</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
			<xsl:text>}&#13;&#13;</xsl:text>
			<xsl:text> 	/// &lt;summary&gt;&#13;</xsl:text>
			<xsl:text>	/// Listener on Failed of DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>&#13;</xsl:text>
			<xsl:text>	/// &lt;/summary&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="sender">&lt;/param&gt;&#13;</xsl:text>
			<xsl:text>	/// &lt;param name="e">Out parameter of the delete action&lt;/param&gt;</xsl:text>
			<xsl:text>&#13;[MFOnActionAttribute(typeof(DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>), ActionLauncher.ActionResult.Failed)]&#13;</xsl:text>
			<xsl:text>public void DoOnDeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/><xsl:text>_Failed(Object sender, ChainedActionArgs e)&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId"><xsl:text>DeleteChained</xsl:text><xsl:value-of select="viewmodel/first-parent-reference"/>-method</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
	</xsl:if>
	<xsl:if test="viewmodel/type/is-list = 'false'">
		<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
		<xsl:text>	&#13;public override CUDActionArgs GetCUDActionArgs()</xsl:text>
		<xsl:text>	{</xsl:text>
		<xsl:text>	return(this.GetCUDActionArgs(Loader));</xsl:text>
		<xsl:text>	}&#13;</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChangedEvent))]&#13;</xsl:text>
    <xsl:text>public void DoOnItemSelected(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChangedEvent e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:text>_selectedId = e.Id;</xsl:text>
    <xsl:text>this.reloadData();</xsl:text>
	<xsl:if test = "../../parameters/parameter[@name = 'workspace-panel-type'] = 'detail' and ../../parameters/parameter[@name = 'grid-section-parameter'] = '1' and  ../../parameters/parameter[@name = 'grid-column-parameter']  = '1' ">
	    <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, new MultiPanel_NavigateSelectedEvent(this));</xsl:text>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-doOnItemSelected-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
    <xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
   	<xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItemEvent))]&#13;</xsl:text>
    <xsl:text>public void DoOnItemAdd(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItemEvent e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:text>_selectedId = e.Id;</xsl:text>
    <xsl:text>this.reloadData();</xsl:text>
	<xsl:if test = "../../parameters/parameter[@name = 'workspace-panel-type'] = 'detail' and ../../parameters/parameter[@name = 'grid-section-parameter'] = '1' and  ../../parameters/parameter[@name = 'grid-column-parameter']  = '1' ">
	    <xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, new MultiPanel_NavigateAddEvent(this));</xsl:text>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-doOnItemAdd-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
    <xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
   	<xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItemEvent))]&#13;</xsl:text>
    <xsl:text>public void DoOnItemDelete(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItemEvent e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">doOnItemDelete-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent() {</xsl:text>
    <xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent myevent = new </xsl:text>
    <xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent();</xsl:text>
    <xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
    <xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	
</xsl:template>


<xsl:template match="navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChanged(object sender, SelectionChangedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
   	<xsl:text>IViewModel vm = (IViewModel)((ListView)sender).SelectedItem;</xsl:text>
	<xsl:text>if(vm != null){</xsl:text>
	<xsl:if test="../../navigations/navigation[@type='NAVIGATION_DETAIL']">
		<xsl:text>if (this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate != null)</xsl:text>
		<xsl:text>this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate(this, e);</xsl:text>               
	</xsl:if>
	<xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChangedEvent myevent = new </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChangedEvent(vm.Id_id);</xsl:text>
	<xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
	<xsl:text>}</xsl:text>
    <xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItem(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
    
	<xsl:choose>
		<xsl:when test="./layout/parameters/parameter[@name = 'vmtype'] = 'LIST_2'">
			<xsl:apply-templates select="../../pages-details/page" mode="method-create-viewmodel-detail-list2d" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="../../navigations/navigation[@type='NAVIGATION_DETAIL']">
				<xsl:text>if (this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate != null)</xsl:text>
				<xsl:text>this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type='NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate(this, e);</xsl:text>               
			</xsl:if>
			<xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItemEvent myevent = new </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItemEvent(-1);</xsl:text>
			<xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
		</xsl:otherwise>
	</xsl:choose>

	<xsl:text>}</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItem(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItemEvent myevent = new </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItemEvent();</xsl:text>
    <xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
    <xsl:text>}&#13;</xsl:text>
    <xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
    <xsl:text>[MFOnEventAttribute(typeof(</xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent))]&#13;</xsl:text>
    <xsl:text>public void DoOnItemReload(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent e)</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:text>this.loadListData(Loader);</xsl:text>
    <xsl:text>}</xsl:text>

</xsl:template>


<xsl:template match="page | dialog" mode="create-action-error-method">
	<xsl:if test="in-multi-panel='false' and in-workspace='false' and not(contains(layout/parameters/parameter/@vmtype, 'LIST'))" >
		<xsl:call-template name="ActionErrorMethod" />
	</xsl:if>
</xsl:template>


<xsl:template match="visualfield" mode="panel-fixedlist-delete-button-impl">
	<xsl:if test="component='MFFixedList'">
		<xsl:text>&#13;/// </xsl:text>
		<xsl:value-of select="./property-name-c"/>
		<xsl:text>button_Delete</xsl:text><xsl:value-of select="layout/prefix"/><xsl:text>_Click</xsl:text>
		<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
		<xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
		<xsl:text>&#13;private void </xsl:text>
		<xsl:value-of select="./property-name-c"/>
		<xsl:text>DeleteButton_Tapped(object sender, RoutedEventArgs e)</xsl:text>
		<xsl:text>&#13;{&#13;</xsl:text>
		<xsl:value-of select="./property-name-c"/>
		<xsl:text>.DeleteItem_Tap(sender, e);&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-DeleteButton_Tapped-method</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		<xsl:text>&#13;}</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template name="ActionErrorMethod">
	<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
	<xsl:text>&#13;/// Display action error message.</xsl:text>
	<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
	<xsl:text>&#13;/// &lt;param name="sender"&gt;Action&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;/// &lt;param name="e"&gt;Message&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;[MFOnEventAttribute(typeof(ActionErrorMessage))]</xsl:text>
	<xsl:text>&#13;public async void DoOnActionError(object sender, ActionErrorMessage e)</xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:if test="./layout/buttons/button[@type='SAVE']">
		<xsl:text>&#13;if (sender.GetType().Equals(typeof(</xsl:text>
		<xsl:value-of select="./layout/buttons/button[@type='SAVE']/@action-name"/>
		<xsl:text>)))</xsl:text>
		<xsl:text>&#13;{</xsl:text>
	</xsl:if>
	<xsl:text>&#13;await Dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, async () =></xsl:text>
	<xsl:text>&#13;{</xsl:text>
	<xsl:text>&#13;// Create the message dialog and set its content</xsl:text>
	<xsl:text>&#13;IMFResourcesHelper resourceLoader = ClassLoader.GetInstance().GetBean&lt;IMFResourcesHelper&gt;();</xsl:text>
	<xsl:text>&#13;var messageDialog = new MessageDialog(</xsl:text>
	<xsl:text>&#13;resourceLoader.getResource(e.ErrorMessage, ResourceFileEnum.FrameWorkFile), </xsl:text>
	<xsl:text>&#13;resourceLoader.getResource("ERROR_MESSAGE", ResourceFileEnum.FrameWorkFile));</xsl:text>
	<xsl:text>messageDialog.Commands.Add(new UICommand("OK"));</xsl:text>
	<xsl:text>&#13;// Show the message dialog</xsl:text>
	<xsl:text>&#13;await messageDialog.ShowAsync();</xsl:text>
	<xsl:text>});</xsl:text>
	<xsl:if test="./layout/buttons/button[@type='SAVE']">
		<xsl:text>&#13;}</xsl:text>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">after-DoOnActionError-method</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;}</xsl:text>
</xsl:template>

	
<xsl:template name="IsList">
	<xsl:choose>
		<xsl:when test="adapter">
			<xsl:text>MFListUserControl</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>MFUserControl</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="page | dialog" mode="method-create-viewmodel-detail-list2d">
	<xsl:text>Button senderButton = sender as Button;</xsl:text>
	<xsl:if test="./in-workspace = 'false'">
		<xsl:text>if (this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type = 'NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate != null)</xsl:text>
		<xsl:text>this.</xsl:text><xsl:value-of select="../../navigations/navigation[@type = 'NAVIGATION_DETAIL']/target/name"/><xsl:text>_Navigate(this, e);</xsl:text>
	</xsl:if>
	<xsl:value-of select="../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_AddItemEvent myevent = new </xsl:text><xsl:value-of select="../../navigationsV2/navigationV2[@type = 'MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_AddItemEvent((long)senderButton.Tag);</xsl:text>
	<xsl:text>ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
	<xsl:text>}</xsl:text>
</xsl:template>


<xsl:template name="SearchClickMethod">
    <xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
    <xsl:text>&#13;/// Launch an action of research on the list.</xsl:text>
    <xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="sender"&gt;SearchButton&lt;/param&gt;</xsl:text>
    <xsl:text>&#13;/// &lt;param name="e"&gt;Event&lt;/param&gt;</xsl:text>
	<xsl:text>&#13;private void </xsl:text><xsl:value-of select="./layout/visualfields/visualfield[component = 'MFList1D']/name"/><xsl:text>_SearchClick(object sender, RoutedEventArgs e)</xsl:text>
    <xsl:text>&#13;{</xsl:text>
    <xsl:text>&#13;// Create Save Action</xsl:text>
    <xsl:text>&#13;// Create Search Action</xsl:text>
    <xsl:text>&#13;SearchActionArgs search</xsl:text><xsl:value-of select="./viewmodel/dataloader-impl/dao-interface/dao/class/name"/><xsl:text>ActionArgs = new SearchActionArgs();</xsl:text>
    <xsl:text>&#13;search</xsl:text><xsl:value-of select="./viewmodel/dataloader-impl/dao-interface/dao/class/name"/><xsl:text>ActionArgs.dataLoader = Loader;</xsl:text>
    <xsl:text>&#13;search</xsl:text><xsl:value-of select="./viewmodel/dataloader-impl/dao-interface/dao/class/name"/><xsl:text>ActionArgs.viewModel = this.</xsl:text>
    <xsl:value-of select="./layout/visualfields/visualfield[component = 'MFList1D']/name"/><xsl:text>.SearchValue;</xsl:text>
	<xsl:text>&#13;// Launch Search Action</xsl:text>
	<xsl:text>&#13;ClassLoader.GetInstance().GetBean<![CDATA[<IMFController>]]>().LaunchAction(typeof(SearchAction), this, search</xsl:text><xsl:value-of select="./viewmodel/dataloader-impl/dao-interface/dao/class/name"/><xsl:text>ActionArgs);</xsl:text>
    <xsl:text>&#13;}</xsl:text>
</xsl:template>

</xsl:stylesheet>

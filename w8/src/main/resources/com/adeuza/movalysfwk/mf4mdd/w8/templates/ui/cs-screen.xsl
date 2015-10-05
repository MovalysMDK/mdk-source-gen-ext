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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

	<xsl:output method="text" />

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/file-header.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/non-generated.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/commons/imports.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/imports.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/partial-class.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/method-click.xsl" />
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/ui/page-type.xsl" />


	<xsl:template match="screen">
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name" />.cs
			</xsl:with-param>
		</xsl:apply-templates>

		<xsl:call-template name="screen-imports" />
		<xsl:text>&#13;</xsl:text>
		<xsl:apply-templates select="." mode="declare-impl-imports" />

		<xsl:choose>
			<xsl:when
					test="(workspace = 'true' or multi-panel = 'true') and (./pages/page/chained-delete='true' or ./pages/page/chained-save='true')">
				<xsl:text>// Chained Action headers</xsl:text>
				<xsl:text>&#13;using </xsl:text><xsl:value-of select="package" /><xsl:text>.action.chainedactions;&#13;</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="page-package">
			<xsl:text>&#13;using </xsl:text><xsl:value-of select="page-package" /><xsl:text>;</xsl:text>
		</xsl:if>
		<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="package" /><xsl:text></xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:call-template name="partial-class">
			<xsl:with-param name="BaseClass">
				<xsl:call-template name="screen-type" />
			</xsl:with-param>
			<xsl:with-param name="Class">
				<xsl:value-of select="name" />
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#13;{</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		</xsl:call-template>

		<xsl:text>String selectPicture = ClassLoader.GetInstance().GetBean&lt;IMFResourcesHelper&gt;().getResource("SelectPicture", ResourceFileEnum.FrameWorkFile);&#13;</xsl:text>

		<xsl:text>&#13;#region Constructors&#13;</xsl:text>

		<xsl:text>public </xsl:text><xsl:value-of select="name" /><xsl:text> ()</xsl:text>
		<xsl:text>{</xsl:text>
		<xsl:text>this.InitializeComponent();</xsl:text>
		<xsl:text>GC.Collect();&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">constructor</xsl:with-param>
		</xsl:call-template>

		<xsl:text>}</xsl:text>

		<xsl:text>&#13;#endregion&#13;</xsl:text>

		<xsl:text>&#13;#region Methods&#13;</xsl:text>

		<xsl:for-each select="layout/buttons/button">
			<xsl:apply-templates select="." mode="method-click" />
		</xsl:for-each>

		<xsl:if test="menus">
			<xsl:text disable-output-escaping="yes"><![CDATA[
		    /// <summary>
		    /// Gestion de la navigation avec le menu de la TopAppBar
		    /// </summary>
		    /// <param name="sender">Menu item</param>
		    /// <param name="e">RoutedEventArgs</param>
			]]></xsl:text>
			<xsl:text>private void Navigation_Click(object sender, RoutedEventArgs e)</xsl:text>
			<xsl:text>{</xsl:text>
			<xsl:text>Button b = sender as Button;</xsl:text>
			<xsl:text>if (b != null &#38;&#38; b.Tag != null)</xsl:text>
			<xsl:text>{</xsl:text>
			<xsl:text>Type pageType = Type.GetType(b.Tag.ToString());</xsl:text>
			<xsl:text>this.Frame.Navigate(pageType);</xsl:text>
			<xsl:text>}</xsl:text>
			<xsl:text>}</xsl:text>
		</xsl:if>

		<xsl:if test="main = 'true'">
			<xsl:if test="is-store = 'false'">
				<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
				<xsl:text>/// Gestion de la reprise après selection d'un fichier via file picker&#13;</xsl:text>
				<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
				<xsl:text>/// &lt;param name="args"&gt;Argument lié au retour du file picker&gt;/param&gt;&#13;</xsl:text>
				<xsl:text>public void ContinueFileOpenPicker(Windows.ApplicationModel.Activation.FileOpenPickerContinuationEventArgs args)&#13;</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>if (args.Files.Count > 0)</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>var fichier = args.Files[0];</xsl:text>
				<xsl:text>if (args.ContinuationData["Operation"].ToString() == selectPicture)</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>FrameworkElement objetParent;</xsl:text>
				<xsl:text>if (args.ContinuationData.ContainsKey("PopupParent"))</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>objetParent = MFTools.FindFirstOpenPopupByName(args.ContinuationData["PopupParent"].ToString()).Child as FrameworkElement;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				<xsl:text>else</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>objetParent = Window.Current.Content as FrameworkElement;</xsl:text>
				<xsl:text>}&#13;</xsl:text>

				<xsl:text>if(objetParent != null)</xsl:text>
				<xsl:text>{&#13;</xsl:text>
				<xsl:text>var photo = MFTools.FindFirstChildByName(args.ContinuationData["ObjetPhoto"].ToString(), objetParent) as MFPhotoThumbnail;</xsl:text>
				<xsl:text>if(photo != null)</xsl:text>
				<xsl:text>photo.ContinueFilePicker(fichier);</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
				<xsl:text>}&#13;</xsl:text>
			</xsl:if>
		</xsl:if>

		<xsl:call-template name="save-delete-multipanel" />

		<xsl:call-template name="navigate-workspace" />

		<xsl:if test="workspace = 'true' or multi-panel = 'true'">
			<xsl:call-template name="ActionErrorMethod" />
		</xsl:if>
		<xsl:text>&#13;#endregion&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
		</xsl:call-template>

		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>

	</xsl:template>

	<xsl:template name="save-delete-multipanel">
		<xsl:if test="workspace = 'true' or multi-panel = 'true'">
			<xsl:if test="./pages/page/chained-save='true'">
				<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
				<xsl:text>&#13;/// Save workspace or MultiPanel.</xsl:text>
				<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;private void btnSave_Click(object sender, RoutedEventArgs e)</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>this.SaveMultiSection();</xsl:text>
				<xsl:text>&#13;    }&#13;</xsl:text>

				<xsl:text>&#13;public override void SaveMultiSection()</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>&#13;    //create chained Action</xsl:text>
				<xsl:text>    &#13;ChainedActionArgs saveChainActionArgs = new ChainedActionArgs();</xsl:text>

				<xsl:text>&#13;    //Fill chained action</xsl:text>
				<xsl:text>&#13;    foreach (MFFWKUserControl userControl in MFPanels.Values)</xsl:text>
				<xsl:text>    {</xsl:text>
				<xsl:text>var control = userControl as MFUserControl;</xsl:text>
				<xsl:text>if (control != null)</xsl:text>
				<xsl:text>{</xsl:text>
				<xsl:text>Object[] tab = control.PrepareSavePanel();</xsl:text>
				<xsl:text>  if (tab != null){</xsl:text>
				<xsl:text>saveChainActionArgs.listActionArgs.Add(tab);</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>    }</xsl:text>
				<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">before-btnSave_Click-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>

				<xsl:text>&#13;		//Launch chained action</xsl:text>
				<xsl:text>&#13;		ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction(typeof(SaveChained</xsl:text>
				<xsl:value-of select="name" />
				<xsl:text>), this, saveChainActionArgs);</xsl:text>

				<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">after-btnSave_Click-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
				<xsl:text>&#13;}&#13;</xsl:text>
			</xsl:if>

			<xsl:if test="./pages/page/chained-delete='true'">
				<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
				<xsl:text>&#13;/// Delete Item.</xsl:text>
				<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="e"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;private void DeleteConfirmation_Click(object sender, RoutedEventArgs e)</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>&#13;    // Dismiss the Flyout after the action is confirmed.</xsl:text>
				<xsl:text>&#13;this.btnDelete.Flyout.Hide();&#13;</xsl:text>
				<xsl:text>&#13;this.DeleteMultiSection();</xsl:text>
				<xsl:text>&#13;base.HidePanels();</xsl:text>
				<xsl:value-of select="viewmodel/name" /><xsl:text>_DeleteItemEvent myevent = new </xsl:text><xsl:value-of
					select="viewmodel/name" /><xsl:text>_DeleteItemEvent();</xsl:text>
				<xsl:text>&#13;ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().RaiseEventMethods(this, myevent);</xsl:text>
				<xsl:text>&#13;}</xsl:text>

				<xsl:text>&#13;public override void DeleteMultiSection()</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>&#13;    //create chained Action</xsl:text>
				<xsl:text>&#13;ChainedActionArgs deleteChainActionArgs = new ChainedActionArgs();</xsl:text>
				<xsl:text>&#13;    //Fill chained action</xsl:text>
				<xsl:text>&#13;foreach (MFFWKUserControl userControl in MFPanels.Values)</xsl:text>
				<xsl:text>{</xsl:text>
				<xsl:text>var control = userControl as MFUserControl;</xsl:text>
				<xsl:text>if (control != null)</xsl:text>
				<xsl:text>{</xsl:text>
				<xsl:text>Object[] tab = control.PrepareDeletePanel();</xsl:text>
				<xsl:text>if (tab != null)</xsl:text>
				<xsl:text>{</xsl:text>
				<xsl:text>deleteChainActionArgs.listActionArgs.Add(tab);</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>}</xsl:text>
				<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">before-btnDelete_Click-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>

				<xsl:text>&#13;    //Launch chained action</xsl:text>
				<xsl:text>&#13;		ClassLoader.GetInstance().GetBean&lt;IMFController&gt;().LaunchAction(typeof(DeleteChained</xsl:text>
				<xsl:value-of select="name" />
				<xsl:text>), this, deleteChainActionArgs);&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">after-btnDelete_Click-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>

				<xsl:text>&#13;}&#13;</xsl:text>
			</xsl:if>

		</xsl:if>
	</xsl:template>

	<xsl:template name="navigate-workspace">
		<xsl:choose>
			<xsl:when test="workspace = 'true'">
				<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
				<xsl:text>&#13;/// Display detail of a selected item.</xsl:text>
				<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="e"&gt;View to display&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;[MFOnEventAttribute(typeof(MultiPanel_NavigateSelectedEvent))]</xsl:text>
				<xsl:text>&#13;public void DoOnMasterItemSelected(object sender, MultiPanel_NavigateSelectedEvent e)</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>&#13;DisplayPanel(e.UC);</xsl:text>
				<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">after-DoOnMasterItemSelected-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
				<xsl:text>&#13;}&#13;</xsl:text>
				<xsl:text>&#13;/// &lt;summary&gt;</xsl:text>
				<xsl:text>&#13;/// Display detail to create a new item.</xsl:text>
				<xsl:text>&#13;/// &lt;/summary&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="sender"&gt;&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;/// &lt;param name="e"&gt;View to display&lt;/param&gt;</xsl:text>
				<xsl:text>&#13;[MFOnEventAttribute(typeof(MultiPanel_NavigateAddEvent))]</xsl:text>
				<xsl:text>&#13;public void DoOnMasterItemAdd(object sender, MultiPanel_NavigateAddEvent e)</xsl:text>
				<xsl:text>&#13;{</xsl:text>
				<xsl:text>&#13;DisplayPanel(e.UC);</xsl:text>
				<xsl:text>&#13;</xsl:text>
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">after-DoOnMasterItemAdd-method</xsl:with-param>
					<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
				<xsl:text>&#13;}&#13;</xsl:text>

			</xsl:when>
		</xsl:choose>
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
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-DoOnActionError-method</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>&#13;}</xsl:text>
	</xsl:template>

</xsl:stylesheet>
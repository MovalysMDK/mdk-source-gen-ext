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
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/imports-common.xsl"/>
<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/w8/templates/view/method-click-common.xsl"/>
 
<xsl:template match="page">

	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>

	<xsl:call-template name="panel-imports"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	
	<xsl:text>&#13;&#13;namespace </xsl:text><xsl:value-of select="package"/><xsl:text></xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class </xsl:text><xsl:value-of select="section-interface"/><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
	<xsl:text>public interface </xsl:text><xsl:value-of select="section-interface"/><xsl:text> : IView</xsl:text>
	<xsl:text>{</xsl:text>
	
	<xsl:text>&#13;#region Properties&#13;</xsl:text>
	<xsl:value-of select="viewmodel-interface/name"/> <xsl:text>  ViewModel { get; set; }&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
	<xsl:text>&#13;#endregion&#13;&#13;</xsl:text> 
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text><xsl:text></xsl:text>
	<xsl:apply-templates select="layout/buttons/button" mode="method-click-interface" />
	<xsl:apply-templates select="." mode="panel-fixedlist-delete-button-interface" />
	<xsl:apply-templates select="navigationsV2/navigationV2" mode="create-event" />
	<xsl:apply-templates select="reverse-navigationsV2/navigationV2" mode="create-event" />
	<xsl:call-template name="panel-state" />
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	<xsl:text>&#13;#endregion&#13;</xsl:text>


	<xsl:text>}</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>

<xsl:template name="panel-state">
<xsl:if test="viewmodel/type/is-list = 'false'">
<xsl:text> 	&#13;&#13;/// &lt;summary&gt;</xsl:text>
<xsl:text> 	&#13;/// Get SaveActionsArg for ChainedSave</xsl:text> 
<xsl:text>	&#13;/// &lt;/summary&gt;</xsl:text>
<xsl:text>	&#13;/// &lt;returns&gt;&lt;/returns&gt;</xsl:text>
<xsl:text>	&#13;CUDActionArgs GetCUDActionArgs();</xsl:text>
</xsl:if>
<xsl:text> 	&#13;&#13;/// &lt;summary&gt;</xsl:text>
<xsl:text> 	&#13;/// Return true if viewmodel must be display.</xsl:text>
<xsl:text>	&#13;/// &lt;/summary&gt;</xsl:text>
<xsl:text> 	&#13;/// &lt;returns&gt;&lt;/returns&gt;</xsl:text>
<xsl:text> 	&#13;Boolean IsToDisplay(AbstractView vm);</xsl:text>

</xsl:template>

<xsl:template match="reverse-navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is selected.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="sender"&gt; object sender of the event.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="e"&gt; event to propagate.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>void DoOnItemSelected(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChangedEvent e);</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is added.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="sender"&gt; object sender of the event.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="e"&gt; event to propagate.&lt;/param&gt;&#13;</xsl:text>
   	<xsl:text>void DoOnItemAdd(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItemEvent e);</xsl:text>
  	<xsl:text>&#13;</xsl:text>
  	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is deleted.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="sender"&gt; object sender of the event.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="e"&gt; event to propagate.&lt;/param&gt;&#13;</xsl:text>
   	<xsl:text>void DoOnItemDelete(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItemEvent e);</xsl:text>
   	<xsl:text>&#13;</xsl:text>
   	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when there is a reload event.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
   	<xsl:text>void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent();</xsl:text>
</xsl:template>

<xsl:template match="navigationsV2/navigationV2[@type = 'MASTER_DETAIL']" mode="create-event" >
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when the selection changed.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="item"&gt; object selected.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_SelectionChanged(object item);</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is added.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="item"&gt; object added.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_AddItem(object item);</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is deleted.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>void </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_DeleteItem();</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// method called when an item is added.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="sender"&gt; object sender of the event.&lt;/param&gt;&#13;</xsl:text>
	<xsl:text>/// &lt;param name="e"&gt; event to propagate.&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>void DoOnItemReload(object sender, </xsl:text><xsl:value-of select="source/component-name-capitalized"/><xsl:text>_ReloadEvent e);</xsl:text>
</xsl:template>

<xsl:template match="page" mode="panel-fixedlist-delete-button-interface">
	<xsl:if test="./layout/visualfields/visualfield/component='MFFixedList'">
		<xsl:text>&#13;void button_Delete</xsl:text>
		<xsl:value-of select="layout/prefix"/>
		<xsl:text>_Click(long id)</xsl:text>
    	<xsl:text>&#13;;</xsl:text>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
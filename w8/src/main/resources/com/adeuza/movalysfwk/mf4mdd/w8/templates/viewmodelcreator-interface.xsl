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

	<xsl:include href="commons/file-header.xsl"/>
	<xsl:include href="commons/imports.xsl"/>
	<xsl:include href="commons/non-generated.xsl"/>
	
	<xsl:include href="ui/viewmodelcreator/interface/list-createupdate-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/interface/listitem-createupdate-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/interface/master-create-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/interface/master-update-vm.xsl"/>
	
	<xsl:key name="viewmodel-name" match="viewmodel" use="implements/interface/@name"/>

<!-- 
ROOT TEMPLATE
-->
<xsl:template match="/master-viewmodelcreator/viewmodelcreator">
	
	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName">I<xsl:value-of select="name"/>.cs</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="declare-protocol-imports"/>
	<xsl:call-template name="viewmodel-imports" />
	
	<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Interface Class of I</xsl:text><xsl:value-of select="name"/><xsl:text> used to create or update others viewmodels.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>	
	<xsl:text>[ScopePolicyAttribute(ScopePolicy.Singleton)]&#13;</xsl:text>
	<xsl:text>public interface I</xsl:text><xsl:value-of select="name"/><xsl:text> {&#13;</xsl:text>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
	<xsl:apply-templates select="./screens/screen/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>
		
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>
		
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/subvm/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/subvm/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>
	
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	
	
	<xsl:apply-templates select="./screens/screen/pages/page/dialogs/dialog/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/dialogs/dialog/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
		
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel" mode="create-vm">
  <xsl:text>// NO MATCH: template[match="viewmodel" mode="create-vm"] for </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> type: </xsl:text><xsl:value-of select="type/name"/>
</xsl:template>
	
<xsl:template match="viewmodel" mode="update-vm">
  <xsl:text>// NO MATCH: template[match="viewmodel" mode="update-vm"] for </xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text> type: </xsl:text><xsl:value-of select="type/name"/>
</xsl:template>


<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>
	
</xsl:stylesheet>
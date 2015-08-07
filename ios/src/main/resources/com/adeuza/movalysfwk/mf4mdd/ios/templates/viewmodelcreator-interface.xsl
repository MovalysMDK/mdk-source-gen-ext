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
	<xsl:include href="commons/constants.xsl"/>
	
	<xsl:include href="ui/viewmodelcreator/interface/list-createupdate-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/interface/listitem-createupdate-vm.xsl"/>

	<xsl:include href="ui/viewmodelcreator/interface/master-create-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/interface/master-update-vm.xsl"/>
	
	<xsl:key name="viewmodel-name" match="viewmodel" use="implements/interface/@name"/>

<!-- 
ROOT TEMPLATE
-->
<xsl:template match="master-viewmodelcreator">
	
	<xsl:apply-templates select="." mode="file-header">
		<xsl:with-param name="fileName"><xsl:value-of select="viewmodelcreator/name"/>.h</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="viewmodelcreator" mode="declare-protocol-imports"/>
		

	<xsl:text>&#13;@interface </xsl:text><xsl:value-of select="name"/><xsl:text> : </xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">class-signature</xsl:with-param>
		<xsl:with-param name="defaultSource">MFDefaultViewModelCreator</xsl:with-param>
	</xsl:call-template>	
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-properties</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">custom-methods</xsl:with-param>
		<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
	
	<xsl:apply-templates select="viewmodelcreator/screens/screen/viewmodel" mode="create-vm"/>
	
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel" mode="create-vm"/>
	<xsl:apply-templates select="./screens/screen/pages/page/viewmodel" mode="update-vm"/>
		
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel" mode="create-vm"/>
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel" mode="update-vm"/>
		
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel" mode="create-vm"/>
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel" mode="update-vm"/>
	
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel" mode="create-vm"/>
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel" mode="create-vm"/>
	
	
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel" mode="create-vm"/>
	<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel" mode="update-vm"/>
	
		
	<xsl:text>@end</xsl:text>
</xsl:template>


<xsl:template match="viewmodel" mode="create-vm">
  // NO MATCH: template[match="viewmodel" mode="create-vm"] for <xsl:value-of select="implements/interface/@name"/> type: <xsl:value-of select="type/name"/>
</xsl:template>
	
<xsl:template match="viewmodel" mode="update-vm">
  // NO MATCH: template[match="viewmodel" mode="update-vm"] for <xsl:value-of select="implements/interface/@name"/> type: <xsl:value-of select="type/name"/>
</xsl:template>


<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>
	
</xsl:stylesheet>
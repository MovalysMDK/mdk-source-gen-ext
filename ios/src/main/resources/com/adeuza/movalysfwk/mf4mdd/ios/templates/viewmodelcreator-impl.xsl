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
	<xsl:include href="commons/non-generated.xsl"/>
	<xsl:include href="commons/constants.xsl"/>
	
	<xsl:include href="ui/viewmodelcreator/impl/external-list.xsl"/>
	<xsl:include href="ui/viewmodelcreator/impl/list-createupdate-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/impl/listitem-createupdate-vm.xsl"/>

	<xsl:include href="ui/viewmodelcreator/impl/master-create-vm.xsl"/>
	<xsl:include href="ui/viewmodelcreator/impl/master-update-vm.xsl"/>

	<xsl:key name="viewmodel-name" match="viewmodel" use="implements/interface/@name"/>

	<!-- 
	ROOT Template
	 -->
	<xsl:template match="master-viewmodelcreator">
	
		<!-- file header -->
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="viewmodelcreator/name"/>.m</xsl:with-param>
		</xsl:apply-templates>
		<xsl:text>#import "</xsl:text><xsl:value-of select="viewmodelcreator/name"/><xsl:text>.h" &#13;&#13;</xsl:text>
		
		<xsl:text>@interface </xsl:text><xsl:value-of select="viewmodelcreator/name"/>()<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">class-extension</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		<xsl:text>&#13;@end&#13;</xsl:text>
		
		<!--  class signature -->
		<xsl:text>@implementation </xsl:text><xsl:value-of select="viewmodelcreator/name"/>
		<xsl:apply-templates select="viewmodelcreator/implements/interface/linked-interfaces" mode="extends"/>
		
		<xsl:text>&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">synthesize</xsl:with-param>
		</xsl:call-template>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-properties</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-methods</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		
		<xsl:text>&#13;&#13;</xsl:text>

		
		<!-- viewmodel creator methods -->
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/viewmodel" mode="create-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel" mode="update-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/external-lists/external-list/viewmodel" mode="update-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel/external-lists/external-list/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel/external-lists/external-list/viewmodel" mode="update-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel" mode="update-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/viewmodel/subvm/viewmodel/subvm/viewmodel/subvm/viewmodel" mode="create-vm"/>
		
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel" mode="create-vm"/>
		<xsl:apply-templates select="viewmodelcreator/screens/screen/pages/page/dialogs/dialog/viewmodel" mode="update-vm"/>
		
		<xsl:text>&#13;@end</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="viewmodel" mode="create-vm">
	  // NO MATCH: template[match="viewmodel" mode="create-vm"] for <xsl:value-of select="implements/interface/@name"/> type: <xsl:value-of select="type/name"/>
	</xsl:template>
	
	<xsl:template match="viewmodel" mode="update-vm">
	  // NO MATCH: template[match="viewmodel" mode="update-vm"] for <xsl:value-of select="implements/interface/@name"/> type: <xsl:value-of select="type/name"/>
	</xsl:template>

</xsl:stylesheet>
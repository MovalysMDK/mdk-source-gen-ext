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
	<xsl:include href="commons/imports.xsl"/>
	
	<xsl:include href="ui/viewmodelcreator/external-list.xsl"/>
	<xsl:include href="ui/viewmodelcreator/create-vm-impl.xsl"/>
	<xsl:include href="ui/viewmodelcreator/update-vm-impl.xsl"/>

	<!-- 
	ROOT Template
	 -->
	<xsl:template match="/master-viewmodelcreator/viewmodelcreator">

		<!-- file header -->
		<xsl:apply-templates select="." mode="file-header">
			<xsl:with-param name="fileName"><xsl:value-of select="name"/>.cs</xsl:with-param>
		</xsl:apply-templates>

		<xsl:apply-templates select="." mode="declare-impl-imports" />
		<xsl:call-template name="viewmodel-imports" />

		<xsl:text>&#13;&#13;</xsl:text>

		<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>

		<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
		<xsl:text>/// Class </xsl:text><xsl:value-of select="./name" /><xsl:text>.&#13;</xsl:text>
		<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
		<!--class signature -->
		<xsl:text>public class </xsl:text><xsl:value-of select="./name" /><xsl:text> : AbstractViewModelCreator, I</xsl:text><xsl:value-of select="./name" />
		<xsl:text>{&#13;</xsl:text>
		<xsl:text>&#13;#region Constructor&#13;&#13;</xsl:text>
		<xsl:text>public </xsl:text><xsl:value-of select="./name" /><xsl:text>()</xsl:text><xsl:text>{</xsl:text>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>&#13;</xsl:text>
		 <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">constructor</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>
		<xsl:text>&#13;</xsl:text>
		<xsl:text>&#13;#endregion&#13;</xsl:text>


		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">custom-properties</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>

		<!-- viewmodel creator methods

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
		<xsl:apply-templates select="./screens/screen/pages/page/dialogs/dialog/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>-->

		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">other-methods</xsl:with-param>
			<xsl:with-param name="defaultSource"/>
		</xsl:call-template>

		<xsl:apply-templates select="./vms/viewmodel[is-screen-viewmodel='false']" mode="create-vm"/>
		<xsl:apply-templates select="./vms/viewmodel[is-screen-viewmodel='false']" mode="update-vm"/>

		<xsl:text>}&#13;</xsl:text>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="viewmodel" mode="create-vm">
		<xsl:text>// NO match create-vm is-list:</xsl:text><xsl:value-of select="type/is-list"/>
		<xsl:text> list:</xsl:text><xsl:value-of select="type/list"/>
		<xsl:text> name:</xsl:text><xsl:value-of select="type/name"/>
	</xsl:template>
	<xsl:template match="viewmodel" mode="update-vm">
		<xsl:text>// NO match update-vm is-list:</xsl:text><xsl:value-of select="type/is-list"/>
		<xsl:text> list:</xsl:text><xsl:value-of select="type/list"/>
		<xsl:text> name:</xsl:text><xsl:value-of select="type/name"/>
	</xsl:template>

	<xsl:template match="viewmodel" mode="declare-impl-imports">
		<xsl:text>// NO match declare-impl-imports</xsl:text>
	</xsl:template>
</xsl:stylesheet>
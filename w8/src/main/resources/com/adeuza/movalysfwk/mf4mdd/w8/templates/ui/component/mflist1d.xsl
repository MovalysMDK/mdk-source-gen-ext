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
		
<!-- DTN - EN COURS DE TRAITEMENT -->
		
<xsl:template match="visualfield[component = 'MFList1D']" mode="create-component">

	<xsl:if test="../../search-template">
		<xsl:text>&lt;mf:MFList1DSearch </xsl:text>
	</xsl:if>
	<xsl:if test="not(../../search-template)">
		<xsl:text>&lt;mf:MFList1D </xsl:text>
	</xsl:if>
	<xsl:text>x:Name="</xsl:text>
	<xsl:call-template name="string-replace-all">
		<xsl:with-param name="text" select="name"/>
		<xsl:with-param name="replace" select="'.'"/>
		<xsl:with-param name="by" select="'_'"/>
	</xsl:call-template>
	<xsl:text>" Grid.Row="</xsl:text>
	<xsl:value-of select="component-position"/>
	<xsl:text>" Grid.Column="0"</xsl:text>
	
	<xsl:choose>
		<xsl:when test="../../adapter and /layout/parameters/parameter[@name = 'vmtype'] = 'LISTITEM_2'">
			<xsl:variable name="viewModelName" select="concat(translate(substring(../../adapter/viewmodel/subvm/viewmodel/mapping/entity[@mapping-type='vmlist']/@vm-property-name,1,1),'v','V'),substring(../../adapter/viewmodel/subvm/viewmodel/mapping/entity[@mapping-type='vmlist']/@vm-property-name,2))"/>
			<xsl:text> mf:Value="{Binding Path=</xsl:text><xsl:value-of select="$viewModelName"/><xsl:text>, Mode=TwoWay}"</xsl:text>
			<!--<xsl:text> mf:OnItemClickCommand="{Binding Path=</xsl:text><xsl:value-of select="$viewModelName"/><xsl:text>.</xsl:text>
			<xsl:value-of select="../../adapter/viewmodel/subvm/viewmodel/subvm/viewmodel/uml-name"/><xsl:text>NavigationDetailCommand}"</xsl:text>-->
		</xsl:when>
		<xsl:otherwise>
			<xsl:text> mf:Value="{Binding}"</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:text> mf:ListTitleContent=""</xsl:text>
	<xsl:text> mf:ListTitleVisibility="Visible"</xsl:text>
	<xsl:text> IsEnabled="True"</xsl:text>

	<xsl:for-each select="/layout/navigations/navigation">
		<xsl:if test="./@type='NAVIGATION_DETAIL' and /layout/parameters/parameter[@name='vmtype']='LIST_1'">
			<xsl:text> mf:OnItemClickCommand="{Binding </xsl:text><xsl:value-of select="./sourcePage/name"/><xsl:text>NavigationDetailCommand}"</xsl:text>
		</xsl:if>
	</xsl:for-each>

	<xsl:if test="/layout/in-multi-panel='true' or /layout/in-workspace='true' and /layout/parameters/parameter[@name='vmtype']='LIST_1'">
		<xsl:text> mf:OnItemClickCommand="{Binding </xsl:text><xsl:value-of select="/layout/prefix"/><xsl:text>NavigationDetailCommand}"</xsl:text>
	</xsl:if>

	<xsl:text> mf:OnAddButtonClickCommand="{Binding </xsl:text><xsl:value-of select="../../shortname"/><xsl:text>AddCommand}"</xsl:text>
	
	<xsl:if test="(/layout/parameters/parameter[@name='vmtype']='LIST_1' and /layout/in-workspace = 'false') or not(/layout/buttons/button[@type = 'NAVIGATION'])">
	<xsl:text> ButtonAddVisibility="Collapsed"</xsl:text>
	</xsl:if>

	<xsl:text> mf:ItemTemplate="{StaticResource </xsl:text>
	<xsl:value-of select="../../adapter/layouts/layout[@id = 'listitem1']/name" />
	<xsl:text>}"</xsl:text>
	<xsl:if test="../../search-template">
		<xsl:text> mf:SearchPanel="</xsl:text>
		<xsl:value-of select="../../search-template" />
		<xsl:text>"</xsl:text>
	</xsl:if>
	
	<xsl:choose>
		<xsl:when test="/layout/parameters/parameter[@name = 'vmtype'] = 'LISTITEM_2'">
			<xsl:text> mf:ElementParentName="</xsl:text>
			<xsl:value-of select="../../adapter/layouts/layout[@id ='list']/visualfields/visualfield[component = 'MFList2D']/name"/>
			<xsl:text>"</xsl:text>
			<xsl:text>&gt;</xsl:text>
           <xsl:text>&lt;&#47;mf:MFList1D&gt;</xsl:text>			
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&#47;&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
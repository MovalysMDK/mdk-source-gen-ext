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
		
<xsl:template match="visualfield[component = 'MFList1D' and ../../search-template] " mode="create-component">

	<xsl:if test="../../search-template">

		<xsl:text>&lt;mf:MFList1DSearch x:Name="</xsl:text>
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
				<xsl:text> mf:Value="{Binding Path=Lst</xsl:text><xsl:value-of select="../../adapter/viewmodel/subvm/viewmodel/mapping/entity[@mapping-type='vmlist']/@vm-type"/><xsl:text>, Mode=TwoWay}"</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> mf:Value="{Binding}"</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:text> mf:ListTitleContent=""</xsl:text>
		<xsl:text> mf:ListTitleVisibility="Visible"</xsl:text>
		<xsl:text> IsEnabled="True"</xsl:text>
		
		<xsl:if test="(/layout/parameters/parameter[@name='vmtype']='LIST_1' and /layout/in-workspace = 'false') or not(/layout/buttons/button[@type = 'NAVIGATION'])">
		<xsl:text> ButtonAddVisibility="Collapsed"</xsl:text>
		</xsl:if>
		
		
		<xsl:if test="./parameters/parameter[@name='master']='true'">
<!-- 			<xsl:if test="../../buttons/button"> -->
<!-- 			</xsl:if> -->
			<xsl:if test="../../navigationsV2/navigationV2">
				<xsl:text> AddClick="</xsl:text>
				<xsl:value-of select="../../navigationsV2/navigationV2[@type='MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_AddItem</xsl:text>
				<xsl:text>"</xsl:text>
				<xsl:text> SearchClick="</xsl:text>
				<xsl:value-of select="../../navigationsV2/navigationV2[@type='MASTER_DETAIL']/source/component-name-capitalized"/><xsl:text>_SearchClick</xsl:text>
				<xsl:text>"</xsl:text>
				<xsl:text> SelectionChanged="</xsl:text>
				<xsl:value-of select="../../navigationsV2/navigationV2[@type='MASTER_DETAIL']/source/component-name-capitalized"/>
				<xsl:text>_SelectionChanged"</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:text> mf:ItemTemplate="{StaticResource </xsl:text>
		<xsl:value-of select="../../adapter/layouts/layout[@id = 'listitem1']/name" />
		<xsl:text>}"</xsl:text>
		<xsl:text> mf:SearchTemplate="{StaticResource </xsl:text>
		<xsl:value-of select="../../search-template" />
		<xsl:text>}"</xsl:text>
		
		<xsl:choose>
			<xsl:when test="/layout/parameters/parameter[@name = 'vmtype'] = 'LISTITEM_2'">
				<xsl:text> mf:ElementParentName="</xsl:text>
				<xsl:value-of select="../../adapter/layouts/layout[@id ='list']/visualfields/visualfield[component = 'MFList2D']/name"/>
				<xsl:text>"</xsl:text>
				<xsl:text>&gt;</xsl:text>
				
				<xsl:text>&lt;mf:MFList1D.FWKEvents&gt;</xsl:text>
                    <xsl:text>&lt;mf:EventManagerCollection&gt;</xsl:text>
                        <xsl:text>&lt;mf:EventManager EventName="SelectionChanged" MethodName="MFList2D_SelectionChanged"&#47;&gt;</xsl:text>
                        <xsl:text>&lt;mf:EventManager EventName="AddClick" MethodName="MFList2D_AddClickOverride"&#47;&gt;</xsl:text>
                    <xsl:text>&lt;&#47;mf:EventManagerCollection&gt;</xsl:text>
                <xsl:text>&lt;&#47;mf:MFList1D.FWKEvents&gt;</xsl:text>
            <xsl:text>&lt;&#47;mf:MFList1D&gt;</xsl:text>			
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#47;&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
		
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
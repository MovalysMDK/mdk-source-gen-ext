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

	<xsl:include href="includes/interface.xsl"/>

	<xsl:template match="master-action-interface">
		<xsl:apply-templates select="action-interface" mode="declare-interface"/>
	</xsl:template>

	<xsl:template match="action-interface" mode="declare-extra-imports">
	
	  
		<xsl:if test="count(./events/event) > 0">
			<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.AbstractCUDEvent</import>
			<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.CUDType</import>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="action-type = 'SAVEDETAIL'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.SaveDetailAction</import>
			</xsl:when>
			<xsl:when test="action-type = 'DELETEDETAIL'">
				<import>com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericdelete.DeleteDetailAction</import>
			</xsl:when>
			
			<xsl:when test="count(./root) = 0 and action-type != 'SAVEDETAIL' and action-type != 'DELETEDETAIL'">
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.action.Action</import>
			</xsl:when>

			<xsl:otherwise>
				<import>com.adeuza.movalysfwk.mobile.mf4mjcommons.business.displaymain.DisplayMainAction</import>
			</xsl:otherwise>
		</xsl:choose>

	
		<xsl:if test="out = 'EntityActionParameterImpl' or count(./events/event)>0">
			<import><xsl:value-of select="class/implements/interface/@full-name"/></import>
		</xsl:if>
		
		<import><xsl:value-of select="class/implements/interface/@full-name"/></import>

	</xsl:template>

	<xsl:template match="action-interface" mode="superinterfaces">
		<xsl:choose>
			<xsl:when test="action-type = 'SAVEDETAIL'">
				<xsl:text>SaveDetailAction&lt;</xsl:text>
				<xsl:value-of select="class/implements/interface/@name"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="step"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="progress"/>
				<xsl:text>></xsl:text>
				
			</xsl:when>
			<xsl:when test="action-type = 'DELETEDETAIL'">
				<xsl:text>DeleteDetailAction&lt;</xsl:text>
				<xsl:value-of select="class/implements/interface/@name"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="step"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="progress"/>
				<xsl:text>></xsl:text>
				
			</xsl:when>
			<xsl:when test="count(./root) = 0 and action-type != 'SAVEDETAIL' and action-type != 'DELETEDETAIL'">
				<xsl:text>Action&lt;</xsl:text>
				<xsl:value-of select="in"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="out"/>

				<!-- TODO: un peu mieux -->
				<xsl:if test="contains('EntityActionParameterImpl', normalize-space(out))">
					<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="class/implements/interface/@name"/>
					<xsl:text>&gt;</xsl:text>
				</xsl:if>

				<xsl:text>,</xsl:text>
				<xsl:value-of select="step"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="progress"/>
				<xsl:text>></xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:text>DisplayMainAction</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="action-interface" mode="methods">
		<xsl:apply-templates select="events/event"/>
	</xsl:template>

	<xsl:template match="event">
		public static class <xsl:value-of select="name"/> extends AbstractCUDEvent&lt;<xsl:value-of select="entity/@name"/>&gt; {
			/**
			 * Constructor
			 * @param p_oSource source event.
			 * @param p_oData <xsl:value-of select="class/implements/interface/@name"/> entity.
			 */
			public <xsl:value-of select="name"/>(Object p_oSource, <xsl:value-of select="entity/@name"/> p_oData) {
				super(p_oSource, p_oData 
				<xsl:if test="@type = 'onchange'">
					<xsl:text>, CUDType.UPDATE</xsl:text>
				</xsl:if>
				<xsl:if test="@type = 'onadd'">
					<xsl:text>, CUDType.CREATE</xsl:text>
				</xsl:if>
				<xsl:if test="@type = 'ondelete'">
					<xsl:text>, CUDType.DELETE</xsl:text>
				</xsl:if>
				<xsl:text>);&#13;</xsl:text>
			}
		}
	</xsl:template>
</xsl:stylesheet>
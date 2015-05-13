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

<xsl:template match="viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3']" mode="create-vm">

/**
 * <p>Create an empty viewmodel.</p>
 * @return An empty view model.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/> ;

/**
 * <p>Create and update a view model<xsl:if test="entity-to-update"> using a <em><xsl:value-of select="entity-to-update/name"/></em></xsl:if>.</p>
 * <xsl:if test="entity-to-update">@param data An instance of <em><xsl:value-of select="entity-to-update/name"/></em>.</xsl:if>
 * @return The view model representation<xsl:if test="entity-to-update"> of an <em><xsl:value-of select="entity-to-update/name"/></em> instance</xsl:if>.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) createOrUpdate<xsl:value-of select="implements/interface/@name"/>
<xsl:if test="entity-to-update">:(<xsl:value-of select="entity-to-update/name"/> *)data</xsl:if> ;
	
</xsl:template>

<xsl:template match="viewmodel[type/name='FIXED_LIST_ITEM']" mode="create-vm">

/**
 * <p>Create an empty viewmodel.</p>
 * @return An empty view model.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/>;

/**
 * <p>Create and update a view model<xsl:if test="entity-to-update"> using a <em><xsl:value-of select="entity-to-update/name"/></em></xsl:if>.</p>
 * <xsl:if test="entity-to-update">@param data An instance of <em><xsl:value-of select="entity-to-update/name"/></em>.</xsl:if>
 * @return The view model representation<xsl:if test="entity-to-update"> of an <em><xsl:value-of select="entity-to-update/name"/></em> instance</xsl:if>.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) createOrUpdate<xsl:value-of select="implements/interface/@name"/>
<xsl:if test="entity-to-update">:(<xsl:value-of select="entity-to-update/name"/><xsl:text> *)data parentVm:(id&lt;MFUIBaseViewModelProtocol&gt;)parentVm</xsl:text></xsl:if> ;
	
</xsl:template>




<xsl:template match="viewmodel[type/name='LISTITEM_1' or type/name='LISTITEM_2' or type/name='LISTITEM_3' or type/name='FIXED_LIST_ITEM']" mode="update-vm">
		<!-- normal: no update for list item viewmodel -->
</xsl:template>

</xsl:stylesheet>
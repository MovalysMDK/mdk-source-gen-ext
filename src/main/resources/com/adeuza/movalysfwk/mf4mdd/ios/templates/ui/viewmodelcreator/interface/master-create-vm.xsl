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



<!-- 
Create method for screen viewmodel : have a parent viewmodel parameter
 -->
<xsl:template match="screen/viewmodel[type/name='MASTER' and not(../workspace='true') and not(../multi-panel='true')]" mode="create-vm">
/**
 * <p>Create an empty viewmodel.</p>
 * @param formController form controller
 * @return An empty view model.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/>
<xsl:text>:(id&lt;MFFormViewControllerProtocol&gt;)formController ;&#13;</xsl:text>
</xsl:template>

<!-- 
Prevent generating vm creator for workspace 
 -->
<xsl:template match="screen/viewmodel[../workspace='true' or ../multi-panel='true']" mode="create-vm">
</xsl:template>

<!-- 
Create method for page viewmodel (without screen/viewmodel) : have a form parameter
 -->
<xsl:template match="viewmodel[(not(ancestor::screen[viewmodel]) and type/name='MASTER') or ( (ancestor::screen[workspace='true'] or ancestor::screen[multi-panel='true']) and type/name='MASTER')]" mode="create-vm">
/**
 * <p>Create an empty viewmodel.</p>
 * @param formController form controller
 * @return An empty view model.
 */
- (<xsl:value-of select="implements/interface/@name"/>*) create<xsl:value-of select="implements/interface/@name"/>
<xsl:text>:(id&lt;MFFormViewControllerProtocol&gt;)formController ;&#13;</xsl:text>

</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="create-vm">
/**
 * <p>Create an empty viewmodel.</p>
 * @param formController form controller
 * @return An empty view model.
 */
- (<xsl:value-of select="type/item"/>*) create<xsl:value-of select="type/item"/>
<xsl:text>:(id&lt;MFFormViewControllerProtocol&gt;)formController ;&#13;</xsl:text>

</xsl:template>

<!-- 
Create method for page viewmodel (with screen/viewmodel)
 -->
<xsl:template match="page/viewmodel[ancestor::screen[viewmodel] and type/name='MASTER' and ancestor::screen[workspace='false'] and ancestor::screen[multi-panel='false']]" mode="create-vm">
	<!-- normal: no createVm for viewmodel having a parent viewmodel -->
</xsl:template>

</xsl:stylesheet>
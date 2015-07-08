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
<xsl:include href="binding/bindingStructure-table.xsl"/>
<xsl:include href="binding/bindingStructure-mixte.xsl"/>
<xsl:include href="binding/bindingStructure-notable.xsl"/>
<xsl:include href="binding/bindingStructure-list.xsl"/>
<xsl:include href="binding/bindingStructure-list2D.xsl"/>

<!-- createBindingStructure method -->
<xsl:template match="controller[@controllerType = 'FORMVIEW'] | 
controller[@controllerType = 'FIXEDLISTVIEW'] |
controller[@controllerType = 'SEARCHVIEW']" mode="createBindingStructure-method">
-(void) createBindingStructure {
	<xsl:choose>
		<xsl:when test="formType = 'TABLE'">
			<xsl:apply-templates select="." mode="createBindingStructure-method-table"/>
		</xsl:when>
		<xsl:when test="formType = 'NO_TABLE'">
			<xsl:apply-templates select="." mode="createBindingStructure-method-notable"/>
		</xsl:when>
		<xsl:when test="formType = 'MIXTE'">
			<xsl:apply-templates select="." mode="createBindingStructure-method-mixte"/>
		</xsl:when>
	</xsl:choose>
}

<xsl:if test="formType = 'MIXTE'">
/**
 * @brief Declares the binding structure of the view of this ViewController
 */
-(void) createViewBindingStructure {
	<xsl:apply-templates select="." mode="createBindingStructure-method-notable"/>
}

/**
 * @brief Declares the binding structure of the tableView of this ViewController
 */
-(void) createTableBindingStructure {
	<xsl:apply-templates select="." mode="createBindingStructure-method-table"/>
}
</xsl:if>

</xsl:template>	


<!-- createBindingStructure method -->
<xsl:template match="controller[@controllerType = 'LISTVIEW']" mode="createBindingStructure-method">
-(void) createBindingStructure {
	<xsl:apply-templates select="." mode="createBindingStructure-method-list"/>
}
</xsl:template>	

<!-- createBindingStructure method -->
<xsl:template match="controller[@controllerType = 'LISTVIEW2D']" mode="createBindingStructure-method">
-(void) createBindingStructure {
	<xsl:apply-templates select="." mode="createBindingStructure-method-list2D"/>
}
</xsl:template>	


</xsl:stylesheet>



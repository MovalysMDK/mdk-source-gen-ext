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

	<xsl:template match="class" mode="extra-methods">
	
		<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
			<!-- 		Function to initialise and add element to any list variables  -->
	    	<xsl:if test="name()= 'association' and  (@type='one-to-many' or @type='many-to-many')">
	    		<xsl:text>&#10;&#10;</xsl:text>
	    		<xsl:text>/**&#10;</xsl:text>
	    		<xsl:text>* Add function for the list </xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>&#10;</xsl:text>
	    		<xsl:text>*/&#10;</xsl:text>
				<xsl:value-of select="../name"/>
				<xsl:text>.prototype.add</xsl:text><xsl:value-of select="@name-capitalized"/>
				<xsl:text>= function (obj) {&#10;if (this.</xsl:text><xsl:value-of select="@name"/>
	       	 	<xsl:text> === null) {&#10;this.</xsl:text><xsl:value-of select="@name"/>
	            <xsl:text> = [];&#10;}&#10;&#10;this.</xsl:text><xsl:value-of select="@name"/>
				<xsl:text>.push(obj);&#10;};&#10;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

</xsl:stylesheet>
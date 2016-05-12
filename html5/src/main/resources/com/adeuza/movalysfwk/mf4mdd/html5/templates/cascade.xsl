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
<!-- Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com) 
	This file is part of Movalys MDK. Movalys MDK is free software: you can redistribute 
	it and/or modify it under the terms of the GNU Lesser General Public License 
	as published by the Free Software Foundation, either version 3 of the License, 
	or (at your option) any later version. Movalys MDK is distributed in the 
	hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied 
	warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
	GNU Lesser General Public License for more details. You should have received 
	a copy of the GNU Lesser General Public License along with Movalys MDK. If 
	not, see <http://www.gnu.org/licenses/>. -->
<!-- Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com) 
	This file is part of Movalys MDK. Movalys MDK is free software: you can redistribute 
	it and/or modify it under the terms of the GNU Lesser General Public License 
	as published by the Free Software Foundation, either version 3 of the License, 
	or (at your option) any later version. Movalys MDK is distributed in the 
	hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied 
	warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
	GNU Lesser General Public License for more details. You should have received 
	a copy of the GNU Lesser General Public License along with Movalys MDK. If 
	not, see <http://www.gnu.org/licenses/>. -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="commons/import.xsl" />

	<xsl:output method="text" indent="yes" omit-xml-declaration="no" />

	<xsl:template match="pojo">
		<xsl:text>'use strict';&#10;</xsl:text>
		<xsl:apply-templates select="." mode="pojo-documentation" />

		<xsl:text>&#10;//@non-generated-start[jshint-override]&#10;</xsl:text>
		<xsl:value-of select="/*/non-generated/bloc[@id='jshint-override']" />
		<xsl:text>//@non-generated-end&#10;&#10;</xsl:text>

		<xsl:apply-templates select="." mode="pojo-prototype" />
		<xsl:text>{&#10;</xsl:text>
		<xsl:apply-templates select="." mode="pojo-body" />
		<xsl:text>}]);&#10;</xsl:text>


	</xsl:template>

	<xsl:template match="pojo/class" mode="pojo-documentation">
		<xsl:text>&#10;/**&#10;</xsl:text>
		<xsl:text>* Enumeration class : </xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade</xsl:text>
		<xsl:text>&#10;*/&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="pojo/class" mode="pojo-prototype">
		<xsl:text>angular.module('data').factory('</xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade', ['MFAbstractEnum', function (MFAbstractEnum)&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="pojo/class" mode="pojo-body">

		<xsl:text>&#10;&#10;var </xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade = function </xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade() {&#10;</xsl:text>

		<xsl:text>this.entityName = '</xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>'; &#10;</xsl:text>
		<xsl:apply-templates select="./association"
			mode="pojo-foreignEntitiesNames" />


		<xsl:text>};&#10;MFAbstractEnum.defineEnum(</xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade, [</xsl:text>

		<xsl:apply-templates select="./association" mode="pojo-values" />

		<xsl:text>]);&#10;&#10;return </xsl:text>
		<xsl:value-of select="name" />
		<xsl:text>Cascade;&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="association" mode="pojo-values">
		<xsl:text>'</xsl:text>
		<xsl:value-of select="@cascade-name" />
		<xsl:text>'</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="association" mode="pojo-foreignEntitiesNames">
		<xsl:if test="position() = 1">
		<xsl:text>this.foreignEntitiesNames = {</xsl:text>
		</xsl:if>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>: '</xsl:text>
		<xsl:value-of select="@name"/>
		<xsl:text>'</xsl:text>
		
		<xsl:choose>
			<xsl:when test="position() != last()">
			<xsl:text>,</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>};&#10; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




</xsl:stylesheet>
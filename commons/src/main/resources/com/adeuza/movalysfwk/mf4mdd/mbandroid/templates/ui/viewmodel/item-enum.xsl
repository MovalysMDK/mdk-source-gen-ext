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

	<xsl:template match="item-enum">
	
	<xsl:text>package </xsl:text><xsl:value-of select="@package"/>;
	import com.adeuza.movalysfwk.mobile.mf4mjcommons.core.ItfItemEnum;
	import com.adeuza.movalysfwk.mobile.mf4mjcommons.core.ItfViewModelCacheBusinessKeyEnum;
	
	public enum ItemEnum implements ItfItemEnum, ItfViewModelCacheBusinessKeyEnum {
	
		<xsl:for-each select="item">
			<xsl:if test="position() > 1">
				<xsl:text>,</xsl:text>
			</xsl:if>
			/**
		 	* Current item
		 	*/
			<xsl:value-of select="."/>
		</xsl:for-each>
	
		//@non-generated-start[methods]
		<xsl:value-of select="non-generated/bloc[@id='methods']"/>
		//@non-generated-end
		;	
	}
	</xsl:template>
</xsl:stylesheet>
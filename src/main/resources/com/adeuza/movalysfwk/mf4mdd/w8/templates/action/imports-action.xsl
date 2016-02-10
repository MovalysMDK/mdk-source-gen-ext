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
		


<!-- permet de créer une import C# à partir de n importe quel texte ou attribut -->
<xsl:template name="action-imports">
	<xsl:text>using mdk_common.MFAction;</xsl:text>
	<xsl:text>using mdk_common.Context;</xsl:text>
	<xsl:text>using mdk_common.Attributs;</xsl:text>
	<xsl:text>using mdk_common.Model;</xsl:text>
	<xsl:text>using mdk_common.Dao;</xsl:text>
	<xsl:text>using mdk_common.ViewModel;</xsl:text>
	<xsl:text>using mdk_common;</xsl:text>
</xsl:template>

</xsl:stylesheet>


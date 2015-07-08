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
		
		<xsl:template match="node()" mode="file-header">
			<xsl:param name="fileName"/>
<xsl:text>//&#13;</xsl:text>
<xsl:text>//  </xsl:text><xsl:value-of select="$fileName"/><xsl:text>&#13;</xsl:text>
<xsl:text>//	</xsl:text><xsl:value-of select="@main-project"/><xsl:text>&#13;</xsl:text>
<xsl:text>//&#13;</xsl:text>
<xsl:text>//  Created by Movalys MDK.&#13;</xsl:text>
<xsl:text>//  Copyright (c) 2012 Sopra Group. All rights reserved.&#13;</xsl:text>
<xsl:text>//&#13;&#13;</xsl:text>
		
		</xsl:template>
		
</xsl:stylesheet>
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

<xsl:output method="xml" indent="yes"/>

<!-- MAX LENGTH for widgets -->
<xsl:template match="visualfield[./max-length]" mode="maxlength">
	<xsl:text>android:maxLength="</xsl:text><xsl:value-of select="./max-length"/><xsl:text>" </xsl:text>
</xsl:template>

<xsl:template match="visualfield[./precision]" mode="maxlength">
	<xsl:text>android:maxLength="</xsl:text><xsl:value-of select="./precision"/><xsl:text>" </xsl:text>
</xsl:template>

<!-- fallback template -->
<xsl:template match="visualfield" mode="maxlength">
</xsl:template>

</xsl:stylesheet>
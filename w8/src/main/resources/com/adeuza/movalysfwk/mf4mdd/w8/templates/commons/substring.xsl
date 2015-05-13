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

<xsl:template name="substring-before-last">
  <xsl:param name="string1" select="''" />
  <xsl:param name="string2" select="''" />

  <xsl:if test="$string1 != '' and $string2 != ''">
    <xsl:variable name="head" select="substring-before($string1, $string2)" />
    <xsl:variable name="tail" select="substring-after($string1, $string2)" />
    <xsl:value-of select="$head" />
    <xsl:if test="contains($tail, $string2)">
      <xsl:value-of select="$string2" />
      <xsl:call-template name="substring-before-last">
        <xsl:with-param name="string1" select="$tail" />
        <xsl:with-param name="string2" select="$string2" />
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

 </xsl:stylesheet>

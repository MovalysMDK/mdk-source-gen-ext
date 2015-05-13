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

<xsl:template match="dao-interface" mode="get-nb">
	<xsl:apply-templates select="." mode="get-nb-sync-async" />
	<xsl:apply-templates select="." mode="get-nb-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>	


<xsl:template match="dao-interface" mode="get-nb-sync-async">
	<xsl:param name="async" />

	<xsl:if test="$async='true'">#region Async&#13;</xsl:if>

	/// &lt;summary&gt;&#13;
    /// Returns the number of <xsl:value-of select="./dao/class/name"/> entities currently found in the database&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The number of <xsl:value-of select="./dao/class/name"/> entities currently found in the database&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> getNb<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(IMFContext p_oContext);&#13;&#13;</xsl:text>	
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>


<xsl:template match="dao" mode="get-nb">
	<xsl:apply-templates select="." mode="get-nb-sync-async" />
	<xsl:apply-templates select="." mode="get-nb-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>	


<xsl:template match="dao" mode="get-nb-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> getNb<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(IMFContext p_oContext) {</xsl:text>
		List&lt;<xsl:value-of select="./interface/name"/>&gt; r_o<xsl:value-of select="./class/name"/>s = <xsl:if test="$async='true'">await </xsl:if>this.GetEntities<xsl:if test="$async='true'">Async</xsl:if>(p_oContext) ;
		return r_o<xsl:value-of select="./class/name"/>s.Count;
	}
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>

</xsl:template>


<xsl:template match="*" mode="get-nb" priority="-900">
	<xsl:comment> [dao-getnb.xsl] <xsl:value-of select="."/> mode='get-nb'</xsl:comment>
</xsl:template>

</xsl:stylesheet>
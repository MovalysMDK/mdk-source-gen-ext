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

<xsl:include href="dao/update/dao-save-or-update-item.xsl"/>

<xsl:template match="dao-interface" mode="save-or-update-list">
	<xsl:apply-templates select="." mode="save-or-update-list-sync-async" />
	<xsl:apply-templates select="." mode="save-or-update-list-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="dao-interface" mode="save-or-update-list-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;</xsl:if>
	
	/// &lt;summary&gt;&#13;
    /// Inserts or updates a list of <xsl:value-of select="./dao/class/name"/> entities&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>s"&gt;The list of entities to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./dao/interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, IMFContext p_oContext);</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates a list of <xsl:value-of select="./dao/class/name"/> entities&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>s"&gt;The list of entities to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./dao/interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, EntitySession p_oEntitySession, IMFContext p_oContext);</xsl:text>
	
	/// &lt;summary&gt;&#13;
    /// Inserts or updates a list of <xsl:value-of select="./dao/class/name"/> entities&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>s"&gt;The list of entities to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./dao/interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, CascadeSet p_oCascadeSet, IMFContext p_oContext);</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates a list of <xsl:value-of select="./dao/class/name"/> entities&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>s"&gt;The list of entities to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./dao/interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;&#13;</xsl:text>
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>


<xsl:template match="dao" mode="save-or-update-list">
	<xsl:apply-templates select="." mode="save-or-update-list-sync-async" />
	<xsl:apply-templates select="." mode="save-or-update-list-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="dao" mode="save-or-update-list-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./class/name-uncapitalized"/>s, CascadeSet.NONE, new EntitySession(), p_oContext);
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, EntitySession p_oEntitySession, IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./class/name-uncapitalized"/>s, CascadeSet.NONE, p_oEntitySession, p_oContext);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, CascadeSet p_oCascadeSet, IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./class/name-uncapitalized"/>s, p_oCascadeSet, new EntitySession(), p_oContext);
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;long&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/>List<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&gt; </xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text>s</xsl:text>
			<xsl:text>, CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-save-list<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		List&lt;long&gt; r_oList = new List&lt;long&gt;();
		
		foreach (<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text> in </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>s) {
			if (!p_oEntitySession.IsAlreadySaved(typeof(<xsl:value-of select="./interface/name"/>), <xsl:value-of select="./class/name-uncapitalized"/>)) {
				<xsl:apply-templates select="." mode="save-or-update-item">
					<xsl:with-param name="async" select="$async"/>
				</xsl:apply-templates>
				r_oList.Add(<xsl:value-of select="./class/name-uncapitalized"/>.<xsl:value-of select="class/identifier/descendant::attribute[1]/@name-capitalized"/>);
			}
		}
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-save-list<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		return r_oList;
	}
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>


<xsl:template match="*" mode="save-or-update-list" priority="-900">
	<xsl:comment> [dao-save-or-update-list.xsl] <xsl:value-of select="."/> mode='save-or-update-list'</xsl:comment>
</xsl:template>


</xsl:stylesheet>
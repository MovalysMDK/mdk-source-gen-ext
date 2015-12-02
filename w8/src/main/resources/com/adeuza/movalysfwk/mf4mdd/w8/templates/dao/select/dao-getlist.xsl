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

<xsl:template match="dao-interface" mode="get-list">
	<xsl:apply-templates select="." mode="get-list-sync-async" />
	<xsl:apply-templates select="." mode="get-list-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="dao-interface" mode="get-list-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;</xsl:if>
	
	/// &lt;summary&gt;&#13;
    /// Returns a list of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;List of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./dao/interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="./dao/class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(IMFContext p_oContext);</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Returns a list of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;List of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./dao/interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="./dao/class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(EntitySession p_oEntitySession, IMFContext p_oContext);</xsl:text>
	
	/// &lt;summary&gt;&#13;
    /// Returns a list of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&#13;
    /// &lt;/summary&gt;&#13;
	/// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;List of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./dao/interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="./dao/class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(CascadeSet p_oCascadeSet, IMFContext p_oContext);</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Returns a list of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;List of all the <xsl:value-of select="./dao/class/name"/> entities found in the database&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./dao/interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="./dao/class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;&#13;</xsl:text>
			
	<xsl:if test="$async='true'">#endregion&#13;</xsl:if>
</xsl:template>


<xsl:template match="dao" mode="get-list">
	<xsl:apply-templates select="." mode="get-list-sync-async" />
	<xsl:apply-templates select="." mode="get-list-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="dao" mode="get-list-sync-async">
	<xsl:param name="async" />
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:variable name="class-name" select="./class/name"/>

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="$class-name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Get<xsl:value-of select="./class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>CascadeSet.NONE, new EntitySession(), p_oContext);</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="$class-name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(EntitySession p_oEntitySession, IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Get<xsl:value-of select="./class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>CascadeSet.NONE, p_oEntitySession, p_oContext);</xsl:text>
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="$class-name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(CascadeSet p_oCascadeSet, IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Get<xsl:value-of select="./class/name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:text>p_oCascadeSet, new EntitySession(), p_oContext);</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> Get<xsl:value-of select="$class-name"/>s<xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-getListClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		List&lt;<xsl:value-of select="interface/name"/>&gt; r_o<xsl:value-of select="$class-name"/>List = <xsl:if test="$async='true'">await </xsl:if>this.GetEntities<xsl:if test="$async='true'">Async</xsl:if>(p_oContext);
        <xsl:variable name="list-object" select="./class/name-uncapitalized"/>
        foreach (<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="$list-object"/> in r_o<xsl:value-of select="$class-name"/>List) {
			
        	p_oEntitySession.AddToCache(typeof(<xsl:value-of select="./interface/name"/>), <xsl:value-of select="./class/name-uncapitalized"/>.<xsl:value-of select="./class/identifier/descendant::attribute[1]/@name-capitalized"/>.ToString(), <xsl:value-of select="./class/name-uncapitalized"/>);
        	<xsl:for-each select="./class/descendant::association[not(@transient='true')]">
			if (p_oCascadeSet.Contains(<xsl:value-of select="$class-name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
			<xsl:choose>
				<xsl:when test="@type='many-to-many' and join-table">
					<xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = (<xsl:value-of select="./dao/name"/>)ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;();
					<xsl:value-of select="$list-object"/>.<xsl:value-of select="@name-capitalized"/><xsl:text> = </xsl:text><xsl:value-of select="./dao/bean-ref"/><xsl:text>.GetList</xsl:text>
					<xsl:choose>
						<xsl:when test="@opposite-navigable='true'">
							<xsl:value-of select="./@name-capitalized"/>By<xsl:value-of select="./@opposite-capitalized-name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./class/name"/>By<xsl:value-of select="$class-name"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>(</xsl:text><xsl:value-of select="$list-object"/><xsl:text>, p_oCascadeSet, p_oEntitySession, p_oContext);</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = (<xsl:value-of select="./dao/name"/>)ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;();
					<xsl:choose>
						<xsl:when test="@type='many-to-many' or @type='one-to-many'">
								<xsl:value-of select="$list-object"/>.<xsl:value-of select="@name-capitalized"/><xsl:text> = </xsl:text>
								<xsl:if test="$async='true'">await </xsl:if>
								<xsl:value-of select="./dao/bean-ref"/><xsl:text>.GetList</xsl:text>
								<xsl:value-of select="./class/name"/>
								<xsl:text>By</xsl:text>
								<xsl:value-of select="@opposite-capitalized-name"/>
								<xsl:if test="$async='true'">Async</xsl:if>
								<xsl:text>(</xsl:text>
								<xsl:value-of select="$list-object"/><xsl:text>, p_oCascadeSet, p_oEntitySession, p_oContext)</xsl:text>
								<xsl:text>;&#13;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$list-object"/>.<xsl:value-of select="@name-capitalized"/> = <xsl:value-of select="./dao/bean-ref"/>.Get<xsl:value-of select="./class/name"/>(<xsl:value-of select="$list-object"/>.<xsl:value-of select="@name-capitalized"/>.<xsl:value-of select="../identifier/descendant::attribute[1]/@name-capitalized"/>, p_oContext);
						</xsl:otherwise> 
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
            }
			</xsl:for-each>
		}
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-getListClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
        return r_o<xsl:value-of select="$class-name"/>List;
	}
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
	
</xsl:template>

<xsl:template match="*" mode="get-list" priority="-900">
	<xsl:comment> [dao-getlist.xsl] <xsl:value-of select="."/> mode='get-list'</xsl:comment>
</xsl:template>


</xsl:stylesheet>
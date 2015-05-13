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

<xsl:template match="dao-interface" mode="save-or-update">
	<xsl:apply-templates select="." mode="save-or-update-sync-async" />
	<xsl:apply-templates select="." mode="save-or-update-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="dao-interface" mode="save-or-update-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;</xsl:if>
	
	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
    	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;</xsl:text>
    </xsl:for-each>
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>IMFContext p_oContext);&#13;</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
    	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;</xsl:text>
    </xsl:for-each>
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>EntitySession p_oEntitySession, IMFContext p_oContext);&#13;</xsl:text>
	
	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
    	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;</xsl:text>
    </xsl:for-each>
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
    	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;</xsl:text>
    </xsl:for-each>
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;</xsl:text>


	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>"&gt;The <xsl:value-of select="./dao/class/name"/> entity to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./dao/interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/>
			<xsl:text>, IMFContext p_oContext);&#13;</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>"&gt;The <xsl:value-of select="./dao/class/name"/> entity to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./dao/interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/>
			<xsl:text>, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;</xsl:text>
	
	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>"&gt;The <xsl:value-of select="./dao/class/name"/> entity to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./dao/interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/>
			<xsl:text>, CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;</xsl:text>

	/// &lt;summary&gt;&#13;
    /// Inserts or updates the given <xsl:value-of select="./dao/class/name"/> entity in the related table&#13;
    /// &lt;/summary&gt;&#13;
    /// &lt;param name="<xsl:value-of select="./dao/class/name-uncapitalized"/>"&gt;The <xsl:value-of select="./dao/class/name"/> entity to insert or update&lt;/param&gt;&#13;
    /// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;
    /// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;
    /// &lt;returns&gt;The unique identifier of the entity after its integration&lt;/returns&gt;&#13;
	<xsl:if test="$async='true'">Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./dao/interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/class/name-uncapitalized"/>
			<xsl:text>, CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;&#13;</xsl:text>

	<xsl:if test="$async='true'">#endregion&#13;</xsl:if>
	
</xsl:template>


<xsl:template match="dao" mode="save-or-update">
	<xsl:apply-templates select="." mode="save-or-update-sync-async" />
	<xsl:apply-templates select="." mode="save-or-update-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="dao" mode="save-or-update-sync-async">
	<xsl:param name="async" />

	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="parameter-name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text>CascadeSet.NONE, new EntitySession(), p_oContext);&#13;</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="parameter-name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text>CascadeSet.NONE, p_oEntitySession, p_oContext);&#13;</xsl:text>
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="parameter-name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each> 
		<xsl:text>p_oCascadeSet, new EntitySession(), p_oContext);&#13;</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:if test="$async='true'">await </xsl:if><xsl:text>this.get</xsl:text><xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="parameter-name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text>p_oCascadeSet, p_oEntitySession, p_oContext)</xsl:text>
		<xsl:text>, p_oCascadeSet, p_oEntitySession, p_oContext);&#13;</xsl:text>
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>
			<xsl:text>, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:value-of select="./class/name-uncapitalized"/>, <xsl:text>CascadeSet.NONE, new EntitySession(), p_oContext);&#13;</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>
			<xsl:text>, EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:value-of select="./class/name-uncapitalized"/>, <xsl:text>CascadeSet.NONE, p_oEntitySession, p_oContext);&#13;</xsl:text>
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>
			<xsl:text>, CascadeSet p_oCascadeSet, IMFContext p_oContext) {&#13;</xsl:text>
		<xsl:text>return </xsl:text><xsl:if test="$async='true'">await </xsl:if>this.Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:value-of select="./class/name-uncapitalized"/>, <xsl:text>p_oCascadeSet, new EntitySession(), p_oContext);&#13;</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>long<xsl:if test="$async='true'">&gt;</xsl:if> Save<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>
			<xsl:text>, CascadeSet p_oCascadeSet, EntitySession p_oEntitySession, IMFContext p_oContext) {&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-save<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		if (!p_oEntitySession.IsAlreadySaved(typeof(<xsl:value-of select="./interface/name"/>), <xsl:value-of select="./class/name-uncapitalized"/>)) {
			<xsl:apply-templates select="." mode="save-or-update-item">
				<xsl:with-param name="async" select="$async"/>
			</xsl:apply-templates>
		}
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-save<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		return <xsl:value-of select="./class/name-uncapitalized"/>.<xsl:value-of select="class/identifier/descendant::attribute[1]/@name-capitalized"/>;
	}
	
	<xsl:if test="$async!='true'">
	public new void Save(<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>, CascadeSet p_oCascadeSet, IMFContext p_oContext)
    {
        this.Save<xsl:value-of select="./class/name"/>(<xsl:value-of select="./class/name-uncapitalized"/>, p_oCascadeSet, p_oContext);
    }
    
    </xsl:if>

	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>


<xsl:template match="*" mode="save-or-update" priority="-900">
	<xsl:comment> [dao-save-or-update.xsl] <xsl:value-of select="."/> mode='save-or-update'</xsl:comment>
</xsl:template>

</xsl:stylesheet>

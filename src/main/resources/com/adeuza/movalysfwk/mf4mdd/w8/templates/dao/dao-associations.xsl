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

<xsl:template match="association" mode="interface">
	<xsl:text>#region ASSOCIATIONS&#13;&#13;</xsl:text>

	<xsl:apply-templates select="." mode="interface-sync-async" />
	<xsl:apply-templates select="." mode="interface-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="association" mode="interface-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:variable name="method-name">GetList<xsl:value-of select="./@opposite-capitalized-name"/>By<xsl:value-of select="./@name-capitalized"/></xsl:variable>

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Returns the list of associated </xsl:text><xsl:value-of select="./opposite-interface/name"/><xsl:text> to the current </xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/><xsl:text>"&gt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> instance to use&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> <xsl:value-of select="$method-name"/><xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/>, EntitySession p_oEntitySession, CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;&#13;	

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Returns the list of associated </xsl:text><xsl:value-of select="./opposite-interface/name"/><xsl:text> to the current </xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/><xsl:text>"&gt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> identifier to use&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> <xsl:value-of select="$method-name"/><xsl:if test="$async='true'">Async</xsl:if>(long <xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>, EntitySession p_oEntitySession, CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;&#13;

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Returns the list of associated </xsl:text><xsl:value-of select="./opposite-interface/name"/><xsl:text> from the association class </xsl:text><xsl:value-of select="./join-table/interface/name"/><xsl:text> for the current </xsl:text><xsl:value-of select="./interface/name"/><xsl:text>&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/><xsl:text>"&gt;</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> identifier to use&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oEntitySession"&gt;Session used for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> getList<xsl:value-of select="./join-table/interface/name"/>By<xsl:value-of select="./join-table/crit-fields/@method-crit-name"/><xsl:if test="$async='true'">Async</xsl:if>(long <xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>, EntitySession p_oEntitySession, IMFContext p_oContext);&#13;&#13;

	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>

</xsl:template>

<xsl:template match="association" mode="implementation">
	<xsl:text>#region ASSOCIATIONS&#13;&#13;</xsl:text>
	
	<xsl:apply-templates select="." mode="implementation-sync-async" />
	<xsl:apply-templates select="." mode="implementation-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="association" mode="implementation-sync-async">
	<xsl:param name="async" />

	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:variable name="method-name">GetList<xsl:value-of select="./@opposite-capitalized-name"/>By<xsl:value-of select="./@name-capitalized"/></xsl:variable>
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> <xsl:value-of select="$method-name"/><xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/>, EntitySession p_oEntitySession, CascadeSet p_oCascadeSet, IMFContext p_oContext)
	{
		return <xsl:if test="$async='true'">await </xsl:if><xsl:value-of select="$method-name"/><xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./join-table/crit-fields/@asso-name"/>.<xsl:value-of select="../identifier/attribute/@name-capitalized"/>, p_oEntitySession, p_oCascadeSet, p_oContext);
	}
	
	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> <xsl:value-of select="$method-name"/><xsl:if test="$async='true'">Async</xsl:if>(long <xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>, EntitySession p_oEntitySession, CascadeSet p_oCascadeSet, IMFContext p_oContext)
    {
    
    	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-getlistbyentity<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
    	
        List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt; r_o<xsl:value-of select="./@opposite-capitalized-name"/> = <xsl:if test="$async='true'">await </xsl:if>this.getList<xsl:value-of select="./join-table/interface/name"/>By<xsl:value-of select="./join-table/crit-fields/@method-crit-name"/><xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>, p_oEntitySession, p_oContext);
        List&lt;long&gt; ids = new List&lt;long&gt;();
        foreach (<xsl:value-of select="./opposite-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/key-fields/@asso-name"/> in r_o<xsl:value-of select="./@opposite-capitalized-name"/>)
        {
            <xsl:value-of select="./opposite-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/key-fields/@asso-name"/>Temp = (<xsl:value-of select="./opposite-interface/name"/>) p_oEntitySession.GetFromCache(typeof(<xsl:value-of select="./opposite-interface/name"/>), <xsl:value-of select="./join-table/key-fields/@asso-name"/>.<xsl:value-of select="../identifier/attribute/@name-capitalized"/>.ToString());
            if (<xsl:value-of select="./join-table/key-fields/@asso-name"/>Temp == null)
            {
                ids.Add(<xsl:value-of select="./join-table/key-fields/@asso-name"/>.<xsl:value-of select="../identifier/attribute/@name-capitalized"/>);
            }
            else 
            {
                r_o<xsl:value-of select="./@opposite-capitalized-name"/>.Add(<xsl:value-of select="./join-table/key-fields/@asso-name"/>Temp);
            }
        }

        r_o<xsl:value-of select="./@opposite-capitalized-name"/>.Concat(<xsl:if test="$async='true'">await </xsl:if>this.GetTableQuery<xsl:if test="$async='true'">Async</xsl:if>(p_oContext).Where(c => ids.Contains(c.<xsl:value-of select="../identifier/attribute/@name-capitalized"/>)).ToList<xsl:if test="$async='true'">Async</xsl:if><xsl:if test="$async!='true'">&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;</xsl:if>());

        if (p_oCascadeSet.Contains(<xsl:value-of select="./method-crit-opposite-name"/>Cascade.<xsl:value-of select="./@cascade-name"/>))
        {
            foreach (<xsl:value-of select="./opposite-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/key-fields/@asso-name"/> in r_o<xsl:value-of select="./@opposite-capitalized-name"/>)
            {
                <!-- <xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = (<xsl:value-of select="./dao/name"/>)ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;(); -->
                foreach (<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/crit-fields/@asso-name"/> in <xsl:value-of select="./join-table/key-fields/@asso-name"/>.<xsl:value-of select="./@name-capitalized"/>)
                {
                    <xsl:value-of select="./join-table/key-fields/@asso-name"/>.<xsl:value-of select="./@name-capitalized"/>.Add(GetTableQuery&lt;<xsl:value-of select="./interface/name"/>&gt;(p_oContext).Where(c =>c.<xsl:value-of select="../identifier/attribute/@name-capitalized"/> == <xsl:value-of select="./join-table/crit-fields/@asso-name"/>.<xsl:value-of select="../identifier/attribute/@name-capitalized"/>).FirstOrDefault());
                }
            }
        }
        
        <xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-getlistbyentity<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
        
        return r_o<xsl:value-of select="./@opposite-capitalized-name"/>;
    }
    
    <xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
    public <xsl:if test="$async='true'">async Task&lt;</xsl:if>List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;<xsl:if test="$async='true'">&gt;</xsl:if> getList<xsl:value-of select="./join-table/interface/name"/>By<xsl:value-of select="./join-table/crit-fields/@method-crit-name"/><xsl:if test="$async='true'">Async</xsl:if>(long <xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>, EntitySession p_oEntitySession, IMFContext p_oContext)
    {
    	
    	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-getlistbyassociation<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
    
        List&lt;<xsl:value-of select="./join-table/interface/name"/>&gt; v<xsl:value-of select="./join-table/interface/name"/>s = <xsl:if test="$async='true'">await </xsl:if>this.GetTableQuery<xsl:if test="$async='true'">Async</xsl:if>&lt;<xsl:value-of select="./join-table/interface/name"/>&gt;(p_oContext).Where(c => c.<xsl:value-of select="./join-table/crit-fields/field/@method-crit-name"/> == <xsl:value-of select="./join-table/crit-fields/field/@attr-name"/>).ToList<xsl:if test="$async='true'">Async</xsl:if><xsl:if test="$async!='true'">&lt;<xsl:value-of select="./join-table/interface/name"/>&gt;</xsl:if>();
        List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt; r_o<xsl:value-of select="./@opposite-capitalized-name"/> = new List&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;();
        foreach (<xsl:value-of select="./join-table/interface/name"/> v<xsl:value-of select="./join-table/interface/name"/> in v<xsl:value-of select="./join-table/interface/name"/>s)
        {
            <xsl:value-of select="./opposite-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./join-table/key-fields/@asso-name"/> = (<xsl:value-of select="./opposite-interface/name"/>)p_oEntitySession.GetFromCache(typeof(<xsl:value-of select="./opposite-interface/name"/>), v<xsl:value-of select="./join-table/interface/name"/>.<xsl:value-of select="./join-table/key-fields/field/@method-crit-name" />.ToString());

            if (<xsl:value-of select="./join-table/key-fields/@asso-name"/> == null)
            {
                <xsl:value-of select="./join-table/key-fields/@asso-name"/> = ClassLoader.GetInstance().GetFactoryByModelInterface&lt;<xsl:value-of select="./opposite-interface/name"/>&gt;().CreateInstance();
            }

            <xsl:value-of select="./join-table/key-fields/@asso-name"/>.<xsl:value-of select="../identifier/attribute/@name-capitalized"/> = v<xsl:value-of select="./join-table/interface/name"/>.<xsl:value-of select="./join-table/key-fields/field/@method-crit-name" />;
            r_o<xsl:value-of select="./@opposite-capitalized-name"/>.Add(<xsl:value-of select="./join-table/key-fields/@asso-name"/>);
        }

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-getlistbyassociation<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>

        return r_o<xsl:value-of select="./@opposite-capitalized-name"/>;
    }
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
	
</xsl:template>

</xsl:stylesheet>

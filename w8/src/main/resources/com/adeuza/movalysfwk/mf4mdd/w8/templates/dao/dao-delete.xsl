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

<xsl:template match="dao-interface" mode="dao-delete">

	<xsl:text>#region DELETE&#13;&#13;</xsl:text>

	<xsl:apply-templates select="." mode="dao-delete-sync-async" />
	<xsl:apply-templates select="." mode="dao-delete-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>

</xsl:template>


<xsl:template match="dao-interface" mode="dao-delete-sync-async">
	<xsl:param name="async" />
	
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Deletes a </xsl:text><xsl:value-of select="./dao/class/name"/><xsl:text> entity given its primary key&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;&#13;</xsl:text>
	</xsl:for-each>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> Delete<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>IMFContext p_oContext);&#13;&#13;</xsl:text>

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Deletes a </xsl:text><xsl:value-of select="./dao/class/name"/><xsl:text> entity given its primary key&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:for-each select="./dao/class/identifier/descendant::attribute">
	<xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="parameter-name"/><xsl:text>"&gt;Primary key element&lt;/param&gt;&#13;</xsl:text>
	</xsl:for-each>
	<xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;Result of the process&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> Delete<xsl:value-of select="./dao/class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./dao/class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;&#13;</xsl:text>
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
	
</xsl:template>


<xsl:template match="dao" mode="dao-delete">
	<xsl:text>#region DELETE&#13;&#13;</xsl:text>

	<xsl:apply-templates select="." mode="dao-delete-sync-async" />
	<xsl:apply-templates select="." mode="dao-delete-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
	
	<xsl:text>#endregion&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="dao" mode="dao-delete-sync-async">
	<xsl:param name="async" />
 
 	<xsl:variable name="class-name" select="./class/name"/>
 
 	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> Delete<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.Delete<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet.NONE, p_oContext);</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	public <xsl:if test="$async='true'">async Task&lt;</xsl:if>int<xsl:if test="$async='true'">&gt;</xsl:if> Delete<xsl:value-of select="./class/name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="./class/identifier/descendant::attribute">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="parameter-name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext) {&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-deleteClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>

 		int r_oResult = 0;
 
 		<xsl:value-of select="./interface/name"/> r_o<xsl:value-of select="$class-name"/> 
			<xsl:text> = null ;</xsl:text>
		
		<xsl:text>r_o</xsl:text><xsl:value-of select="$class-name"/><xsl:text> = </xsl:text>
		<xsl:if test="$async='true'">await </xsl:if><xsl:text>this.Get</xsl:text><xsl:value-of select="$class-name"/>
		<xsl:if test="$async='true'">Async</xsl:if><xsl:text>(</xsl:text>
		<xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="parameter-name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text> p_oCascadeSet, p_oContext);</xsl:text>
		
		<xsl:text> if (r_o</xsl:text><xsl:value-of select="$class-name"/><xsl:text> != null) {</xsl:text>
		
 		<xsl:for-each select="./delete-cascade/cascade">
			<xsl:variable name="name" select="./@name" />
	 		<xsl:for-each select="../../class/descendant::association[@cascade-name=$name]">
		if (p_oCascadeSet.Contains(<xsl:value-of select="../../class/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
		   	<xsl:value-of select="./dao-interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;();
		    
		    <xsl:choose>
				<xsl:when test="@type='many-to-many' or @type='one-to-many'">
					<xsl:text>foreach (</xsl:text><xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./variable-name"/> in r_o<xsl:value-of select="$class-name"/>.<xsl:value-of select="./@name-capitalized"/><xsl:text>) {&#13;</xsl:text>
						r_oResult += <xsl:if test="$async='true'">await </xsl:if><xsl:value-of select="./dao/bean-ref"/>.DeleteEntity<xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="./variable-name"/>, p_oContext);
					}
				</xsl:when>
				<xsl:otherwise>
					r_oResult += <xsl:if test="$async='true'">await </xsl:if><xsl:value-of select="./dao/bean-ref"/>.DeleteEntity<xsl:if test="$async='true'">Async</xsl:if>(r_o<xsl:value-of select="$class-name"/>.<xsl:value-of select="./@name-capitalized"/>, p_oContext);
				</xsl:otherwise> 
			</xsl:choose>		    		    
		}
	    	</xsl:for-each>
	    </xsl:for-each>

		r_oResult += <xsl:if test="$async='true'">await </xsl:if>this.DeleteEntity<xsl:if test="$async='true'">Async</xsl:if>(r_o<xsl:value-of select="$class-name"/>, p_oContext);
		}
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-deleteClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>

        return r_oResult;
 	}
 	
	<xsl:if test="$async!='true'">
	public new void Delete(<xsl:value-of select="./interface/name"/><xsl:text> </xsl:text><xsl:value-of select="./class/name-uncapitalized"/>, CascadeSet p_oCascadeSet, IMFContext p_oContext)
    {
    	<xsl:text>if(</xsl:text><xsl:value-of select="./class/name-uncapitalized"/><xsl:text> != null)</xsl:text>
    	<xsl:text>{&#13;</xsl:text>
    	<xsl:text>this.Delete</xsl:text><xsl:value-of select="./class/name"/><xsl:text>(</xsl:text>
        <xsl:for-each select="./class/identifier/descendant::attribute">
			<xsl:value-of select="../../name-uncapitalized"/>.<xsl:value-of select="@name-capitalized"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
        <xsl:text>p_oCascadeSet, p_oContext);&#13;</xsl:text>
        <xsl:text>}&#13;</xsl:text>
    }
    
    </xsl:if>

	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>

</xsl:template>

</xsl:stylesheet>

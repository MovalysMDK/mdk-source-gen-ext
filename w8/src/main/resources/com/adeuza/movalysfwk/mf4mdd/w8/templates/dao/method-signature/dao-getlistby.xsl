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

<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="interface">
	<xsl:apply-templates select="." mode="interface-sync-async" />
	<xsl:apply-templates select="." mode="interface-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="interface-sync-async">
	<xsl:param name="async" />
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>
	
	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Returns the list of </xsl:text><xsl:value-of select="../class/name"/><xsl:text> entities having the given attributes values&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:for-each select="method-parameter">
    <xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="@name"/><xsl:text>"&gt;</xsl:text>The value for the <xsl:value-of select="@name"/> attribute<xsl:text>&lt;/param&gt;&#13;</xsl:text>
    </xsl:for-each>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;List of entities found&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>
		<xsl:text>List&lt;</xsl:text><xsl:value-of select="return-type/@contained-type-short-name"/><xsl:text>&gt;</xsl:text>
		<xsl:if test="$async='true'">&gt;</xsl:if>
		<xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:if test="$async='true'">Async</xsl:if>
		<xsl:text>(</xsl:text>
		<xsl:for-each select="method-parameter">
			<xsl:value-of select="@type-short-name"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text>IMFContext p_oContext);&#13;&#13;</xsl:text>

	<xsl:text>/// &lt;summary&gt;&#13;</xsl:text>
    <xsl:text>/// Returns the list of </xsl:text><xsl:value-of select="../class/name"/><xsl:text> entities having the given attributes values&#13;</xsl:text>
    <xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
    <xsl:for-each select="method-parameter">
    <xsl:text>/// &lt;param name="</xsl:text><xsl:value-of select="@name"/><xsl:text>"&gt;</xsl:text>The value for the <xsl:value-of select="@name"/> attribute<xsl:text>&lt;/param&gt;&#13;</xsl:text>
    </xsl:for-each>
    <xsl:text>/// &lt;param name="p_oCascadeSet"&gt;CascadeSet applied to the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;param name="p_oContext"&gt;Context for the operation&lt;/param&gt;&#13;</xsl:text>
    <xsl:text>/// &lt;returns&gt;List of entities found&lt;/returns&gt;&#13;</xsl:text>
	<xsl:if test="$async='true'">Task&lt;</xsl:if>
		<xsl:text>List&lt;</xsl:text><xsl:value-of select="return-type/@contained-type-short-name"/><xsl:text>&gt;</xsl:text>
		<xsl:if test="$async='true'">&gt;</xsl:if>
		<xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:if test="$async='true'">Async</xsl:if>
		<xsl:text>(</xsl:text>
		<xsl:for-each select="method-parameter">
			<xsl:value-of select="@type-short-name"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="@name"/>
			<xsl:text>, </xsl:text>
		</xsl:for-each>
		<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext);&#13;&#13;</xsl:text>
	
	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>


<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="implementation">
	<xsl:apply-templates select="." mode="implementation-sync-async" />
	<xsl:apply-templates select="." mode="implementation-sync-async">
		<xsl:with-param name="async" select="'true'"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="method-signature[@type='getListEntite' and @by-value='false']" mode="implementation-sync-async">
	<xsl:param name="async" />
	<xsl:if test="$async='true'">#region Async&#13;&#13;</xsl:if>

	<xsl:variable name="class-name" select="../class/name"/>

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text>
			<xsl:if test="$async='true'">async Task&lt;</xsl:if>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="return-type/@contained-type-short-name"/><xsl:text>&gt;</xsl:text>
			<xsl:if test="$async='true'">&gt;</xsl:if>
			<xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>IMFContext p_oContext) {</xsl:text>
		return <xsl:if test="$async='true'">await </xsl:if>this.<xsl:value-of select="@name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet.NONE, p_oContext);</xsl:text>
	}

	<xsl:text>/// &lt;inheritDoc /&gt;&#13;</xsl:text>
	<xsl:value-of select="@visibility"/><xsl:text> </xsl:text>
			<xsl:if test="$async='true'">async Task&lt;</xsl:if>
			<xsl:text>List&lt;</xsl:text><xsl:value-of select="return-type/@contained-type-short-name"/><xsl:text>&gt;</xsl:text>
			<xsl:if test="$async='true'">&gt;</xsl:if>
			<xsl:text> </xsl:text> <xsl:value-of select="@name"/><xsl:if test="$async='true'">Async</xsl:if>
			<xsl:text>(</xsl:text>
			<xsl:for-each select="method-parameter">
				<xsl:value-of select="@type-short-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="@name"/>
				<xsl:text>, </xsl:text>
			</xsl:for-each>
			<xsl:text>CascadeSet p_oCascadeSet, IMFContext p_oContext) {&#13;</xsl:text>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">before-getListClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>
		
		List&lt;<xsl:value-of select="../interface/name"/>&gt; r_o<xsl:value-of select="$class-name"/>s = null ;
		
		<xsl:choose>
			<xsl:when test="count(method-parameter) = 1 and method-parameter/association and method-parameter/association/@type='many-to-many'">
				<xsl:text>r_o</xsl:text><xsl:value-of select="$class-name"/>s = <xsl:value-of select="method-parameter/@name"/>.<xsl:value-of select="$class-name"/><xsl:text>s;&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>r_o</xsl:text><xsl:value-of select="$class-name"/>s = <xsl:if test="$async='true'">await </xsl:if>this.GetTableQuery<xsl:if test="$async='true'">Async</xsl:if><xsl:text>(p_oContext).Where(c =&gt;</xsl:text>
				<xsl:for-each select="method-parameter">
					<xsl:choose>
						<xsl:when test="./@by-value='true'">
							<xsl:text>c.</xsl:text><xsl:value-of select="./@name-capitalized"/><xsl:text> == </xsl:text> <xsl:value-of select="./@name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>c.</xsl:text><xsl:value-of select="./association/@name-capitalized"/>.<xsl:value-of select="./association/descendant::attribute[1]/@name-capitalized"/> <xsl:text> == </xsl:text> <xsl:value-of select="./@name"/>.<xsl:value-of select="./association/descendant::attribute[1]/@name-capitalized"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="position() != last()">
						<xsl:text disable-output-escaping="yes"> <![CDATA[&]]> </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>).ToList</xsl:text><xsl:if test="$async='true'">Async</xsl:if><xsl:text>();&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="../class/association">
		foreach (<xsl:value-of select="../interface/name"/><xsl:text> </xsl:text><xsl:value-of select="../class/name-uncapitalized"/> in r_o<xsl:value-of select="$class-name"/>s) {
		
	        <xsl:for-each select="../class/descendant::association[not(@transient='true')]">
       		if (p_oCascadeSet.Contains(<xsl:value-of select="../../class/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
			<xsl:choose>
				<xsl:when test="@type='many-to-many' and join-table">
					<xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = (<xsl:value-of select="./dao/name"/>)ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;();
					<xsl:value-of select="../name-uncapitalized"/>.<xsl:value-of select="@name-capitalized"/><xsl:text> = </xsl:text><xsl:if test="$async='true'">await </xsl:if><xsl:value-of select="./dao/bean-ref"/>.GetList<xsl:value-of select="./@name-capitalized"/>By<xsl:value-of select="./@opposite-capitalized-name"/><xsl:if test="$async='true'">Async</xsl:if>(<xsl:value-of select="../name-uncapitalized"/>, new EntitySession(), p_oCascadeSet, p_oContext);
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./dao/name"/><xsl:text> </xsl:text><xsl:value-of select="./dao/bean-ref"/> = (<xsl:value-of select="./dao/name"/>)ClassLoader.GetInstance().GetBean&lt;<xsl:value-of select="./dao-interface/name"/>&gt;();
					<xsl:choose>
						<xsl:when test="@type='many-to-many' or @type='one-to-many'">
							<xsl:value-of select="../name-uncapitalized"/>.<xsl:value-of select="@name-capitalized"/><xsl:text>.AddRange(</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../name-uncapitalized"/>.<xsl:value-of select="@name-capitalized"/><xsl:text> = </xsl:text>
						</xsl:otherwise> 
					</xsl:choose>
					<xsl:if test="$async='true'">await </xsl:if>GetTableQuery<xsl:if test="$async='true'">Async</xsl:if>&lt;<xsl:value-of select="./interface/name"/>&gt;<xsl:text>(p_oContext).Where(c =></xsl:text>
					<xsl:choose>
						<xsl:when test="@type='many-to-many' or @type='one-to-many'">
							<xsl:text>c.</xsl:text><xsl:value-of select="./@opposite-capitalized-name"/>.<xsl:value-of select="../identifier/descendant::attribute[1]/@name-capitalized"/><xsl:text> == </xsl:text>
							<xsl:value-of select="../name-uncapitalized"/>.<xsl:value-of select="../identifier/descendant::attribute[1]/@name-capitalized"/>
							<xsl:text>).ToList</xsl:text><xsl:if test="$async='true'">Async</xsl:if><xsl:text>());&#13;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>c.</xsl:text><xsl:value-of select="../identifier/descendant::attribute[1]/@name-capitalized"/><xsl:text> == </xsl:text>
							<xsl:value-of select="../name-uncapitalized"/>.<xsl:value-of select="@name-capitalized"/>.<xsl:value-of select="../identifier/descendant::attribute[1]/@name-capitalized"/>
							<xsl:choose>
								<xsl:when test="@type-name='List'">
									<xsl:text>).ToList</xsl:text><xsl:if test="$async='true'">Async</xsl:if><xsl:text>();&#13;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>).FirstOrDefault</xsl:text><xsl:if test="$async='true'">Async</xsl:if><xsl:text>();&#13;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>						
						</xsl:otherwise> 
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			}
			</xsl:for-each>
		}
		</xsl:if>
		<xsl:text>&#13;</xsl:text>

		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">after-getListClass<xsl:if test="$async='true'">-async</xsl:if></xsl:with-param>
		</xsl:call-template>

        return r_o<xsl:value-of select="$class-name"/>s;
	}	

	<xsl:if test="$async='true'">#endregion&#13;&#13;</xsl:if>
</xsl:template>

</xsl:stylesheet>
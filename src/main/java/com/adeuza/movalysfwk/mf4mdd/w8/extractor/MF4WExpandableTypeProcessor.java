/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.extractor;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.types.ExpandableType;
import com.a2a.adjava.types.ITypeDescription;
import com.a2a.adjava.uml.UmlAttribute;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlDataType;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml.UmlPackage;
import com.a2a.adjava.uml.UmlStereotype;
import com.a2a.adjava.uml2xmodele.extractors.ExpandableTypeProcessor;
import com.a2a.adjava.uml2xmodele.extractors.PojoContext;

public class MF4WExpandableTypeProcessor extends ExpandableTypeProcessor {
	
	/** Complex entity prefix */
	public static final String COMPLEX_ENTITY_W8 = "COMPLEX_ENTITY_W8";
		
	/**
	 * Private constructor
	 */
	public MF4WExpandableTypeProcessor() {
		//Empty constructor
		super();
	}

	/**
	 * Treat expandable attributes
	 * @param p_oModele uml modele
	 * @param p_oContext context
	 */
	public void expandAttributes(UmlModel p_oModele, PojoContext p_oContext ) throws Exception {
		super.expandAttributes(p_oModele, p_oContext);
		List<UmlClass> entities = new ArrayList<UmlClass>();
		for(UmlClass oUmlClass : p_oModele.getDictionnary().getAllClasses()) {
			if (p_oContext.isEntity(oUmlClass)) {
				for(UmlAttribute oUmlAttribute : oUmlClass.getAttributes()) {
					ITypeDescription oTypeDesc = p_oContext.getDomain().getDictionnary().getTypeDescription(
							oUmlAttribute.getDataType().getName());
					if ( oTypeDesc != null && !(oTypeDesc.getExpandableType().equals(ExpandableType.ONE_TO_MANY) ||
								oTypeDesc.getExpandableType().equals(ExpandableType.ONE_TO_ONE)) && !oTypeDesc.getProperties().isEmpty() ) {
						ITypeDescription oNewUmlType = (ITypeDescription) oTypeDesc.clone();
						String sShortName = StringUtils.capitalize(oUmlClass.getName()) + StringUtils.capitalize(oUmlAttribute.getName());
						String sPackage = oUmlClass.getPackage().getFullName();
						oNewUmlType.setName(sPackage + "." + sShortName);
						oNewUmlType.setInitFormat("new " + sShortName + "()");
						p_oContext.getDomain().getDictionnary().registerTypeDescription(oNewUmlType.getName(), oNewUmlType);
						oUmlAttribute.setDataType(new UmlDataType(oNewUmlType.getName()));
						UmlPackage oPackage = null;
						for (String subPackage : sPackage.split("\\.")){
							oPackage = new UmlPackage(subPackage, oPackage);
						}
						
						UmlClass entityClass = this.expandAttrBegin(oUmlAttribute, oNewUmlType, oNewUmlType.getShortName(), oPackage, oTypeDesc.getExpandableType(), entities, p_oModele, p_oContext);
						entityClass.addStereotype(new UmlStereotype(p_oContext.getTranscientStereotypes().get(0),p_oContext.getTranscientStereotypes().get(0)));
						entityClass.addStereotype(new UmlStereotype(p_oContext.getEntityStereotypes().get(0),p_oContext.getEntityStereotypes().get(0)));
						entityClass.addStereotype(new UmlStereotype(COMPLEX_ENTITY_W8 + ";" + oTypeDesc.getName() + ";" + oUmlClass.getFullName() + ";" + oUmlAttribute.getName(), COMPLEX_ENTITY_W8 + ";" +oTypeDesc.getName() + ";" + oUmlClass.getFullName() + ";" + oUmlAttribute.getName()));
						entities.add(entityClass);
					}
				}
			}			
		}
		
		for( UmlClass oUmlEntity: entities ) {
			p_oModele.getDictionnary().registerClass(
				Long.toString(oUmlEntity.getName().hashCode()), oUmlEntity);
		}
	}
			

}
